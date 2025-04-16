-- Maps leader, should be before Lazy
require("lawqup.remap")
require("lawqup.lazy")
require("lawqup.ui")

vim.api.nvim_set_option("clipboard", "unnamed")

require("mini.misc").setup_auto_root()

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	callback = function()
-- 		local mode = vim.api.nvim_get_mode().mode
-- 		local filetype = vim.bo.filetype
-- 		if vim.bo.modified == true and mode == 'n' and filetype == "rust" then
-- 			vim.cmd('lua vim.lsp.buf.format()')
-- 		else
-- 		end
-- 	end
-- })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "cucumber",
	callback = function()
		vim.opt_local.tabstop = 4 -- A TAB character looks like 4 spaces
		vim.opt_local.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
		vim.opt_local.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
		vim.opt_local.shiftwidth = 4 -- Number of spaces inserted when indenting
	end
})

function AddMacroToClangd(macro)
	-- Remove leading "-D" if present
	local clean_macro = macro:gsub("^-D", "")

	-- Path to .clangd file (using project root)
	local clangd_path = vim.fn.getcwd() .. "/.clangd"

	-- Check if file exists
	local file_exists = vim.fn.filereadable(clangd_path) == 1

	-- Read existing content or create template
	local content = ""
	if file_exists then
		local lines = vim.fn.readfile(clangd_path)
		content = table.concat(lines, "\n")
	else
		content = "CompileFlags:\n  Add:\n"
	end

	-- Check if the macro is already in the file
	if content:find(clean_macro) then
		print("Macro " .. clean_macro .. " already exists in .clangd")
		return
	end

	-- Find where to insert the new macro
	local add_section = content:match("CompileFlags:%s*\n%s*Add:%s*\n")
	if add_section then
		-- Add section exists, append to it
		local new_content = content:gsub("(CompileFlags:%s*\n%s*Add:%s*\n)", "%1    - -D" .. clean_macro .. "=1\n")
		vim.fn.writefile(vim.fn.split(new_content, "\n"), clangd_path)
	else
		-- No Add section, check if CompileFlags exists
		local compile_flags = content:match("CompileFlags:")
		if compile_flags then
			-- CompileFlags exists but no Add section
			local new_content = content:gsub("(CompileFlags:)", "%1\n  Add:\n    - -D" .. clean_macro .. "=1")
			vim.fn.writefile(vim.fn.split(new_content, "\n"), clangd_path)
		else
			-- No CompileFlags section, create everything
			local new_content = "CompileFlags:\n  Add:\n    - -D" .. clean_macro .. "=1\n" .. content
			vim.fn.writefile(vim.fn.split(new_content, "\n"), clangd_path)
		end
	end

	print("Added macro " .. clean_macro .. " to .clangd")

	-- Optionally restart clangd
	vim.cmd("LspRestart clangd")
end


function GetDefinedMacros()
	if DefinedMacros ~= nil then
		return DefinedMacros
	end

	-- Find cscope database
	local cscope_dir = "./"
	for _ = 1, 10, 1 do
		if vim.fn.filereadable(cscope_dir .. "cscope.out") == 1 then
			break
		end

		cscope_dir = cscope_dir .. "../"
	end

	-- Use cscope to find #define statements
	local cmd = "cd " .. cscope_dir .. "&& cscope -R -L -0 '.*' 2> /dev/null |  grep -E '#ifdef|#ifndef'  | awk -F ' ' '{print $5}' | sort | uniq";
	local handle = io.popen(cmd)
	if not handle then
		print("Failed to run cscope command")
		return {}
	end

	local result = handle:read("*a")
	handle:close()

	-- Parse the output to extract macro names
	local macros = {}
	local seen = {}

	for macro in result:gmatch("[^\r\n]+") do
		if macro and not seen[macro] then
			seen[macro] = true
			table.insert(macros, macro)
		end
	end


	DefinedMacros = macros
	return DefinedMacros
end

function FilterMacrosByPrefix(macros, prefix, max_results)
	local matches = {}
	local count = 0

	-- First, try exact prefix match (case-sensitive)
	for _, macro in ipairs(macros) do
		if macro:sub(1, #prefix) == prefix then
			table.insert(matches, macro)
			count = count + 1
			if count >= max_results then
				return matches
			end
		end
	end

	-- If we haven't reached max_results, try case-insensitive prefix match
	if count < max_results then
		local lower_prefix = prefix:lower()
		for _, macro in ipairs(macros) do
			if macro:lower():sub(1, #lower_prefix) == lower_prefix and not vim.tbl_contains(matches, macro) then
				table.insert(matches, macro)
				count = count + 1
				if count >= max_results then
					return matches
				end
			end
		end
	end

	-- If we still haven't reached max_results, try substring match
	if count < max_results and #prefix > 0 then
		for _, macro in ipairs(macros) do
			if macro:lower():find(prefix:lower(), 1, true) and not vim.tbl_contains(matches, macro) then
				table.insert(matches, macro)
				count = count + 1
				if count >= max_results then
					return matches
				end
			end
		end
	end

	return matches
end

function CwordOrArgs(args)
	if args and args ~= "" then
		-- Use the provided argument
		return args
	end

	local cword = vim.fn.expand('<cword>')
	if cword and cword ~= "" then
		-- Use the word under cursor
		return cword
	end

	error("No word under cursor and no arg provided")
end


-- Create the command
vim.api.nvim_create_user_command("CMacroAdd",
	function(opts) AddMacroToClangd(CwordOrArgs(opts.args)) end,
	{
		nargs = '?',
		desc = "Add a macro definition to .clangd file",
		complete = function(ArgLead, CmdLine, CursorPos)
			local macros = GetDefinedMacros()
			assert(macros ~= nil)

			return FilterMacrosByPrefix(macros, ArgLead, 25)
		end
	}
)

function DeleteMacroFromClangd(macro)
	-- Remove leading "-D" if present
	local clean_macro = macro:gsub("^-D", "")

	-- Path to .clangd file
	local clangd_path = vim.fn.getcwd() .. "/.clangd"

	-- Check if file exists
	if vim.fn.filereadable(clangd_path) ~= 1 then
		print("No .clangd file found")
		return
	end

	-- Read existing content
	local lines = vim.fn.readfile(clangd_path)

	-- Look for the macro line
	local pattern = "%s*%-%s*%-D" .. clean_macro .. "=?%d*"
	local new_lines = {}
	local found = false

	for _, line in ipairs(lines) do
		if line:match(pattern) then
			found = true
			-- Skip this line (don't add to new_lines)
		else
			table.insert(new_lines, line)
		end
	end

	if not found then
		print("Macro " .. clean_macro .. " not found in .clangd")
		return
	end

	-- Clean up empty Add section if needed
	local i = 1
	while i <= #new_lines do
		-- If we find an Add: line followed by a non-indented line or EOF, remove the Add: line
		if new_lines[i]:match("%s*Add:%s*$") and
			(i == #new_lines or not new_lines[i+1]:match("^%s+%-")) then
			table.remove(new_lines, i)
		else
			i = i + 1
		end
	end

	-- Write the updated content back
	vim.fn.writefile(new_lines, clangd_path)
	print("Removed macro " .. clean_macro .. " from .clangd")

	-- Optionally restart clangd
	vim.cmd("LspRestart clangd")
end

function GetAddedMacros()
  local clangd_path = vim.fn.getcwd() .. "/.clangd"

  -- Check if file exists
  if vim.fn.filereadable(clangd_path) ~= 1 then
    return {}
  end

  local lines = vim.fn.readfile(clangd_path)
  local macros = {}

  -- Look for macro definitions in the format "- -DMACRO=1"
  for _, line in ipairs(lines) do
    local macro = line:match("%s*%-%s*%-D([%w_]+)=?%d*")
    if macro then
      table.insert(macros, macro)
    end
  end

  return macros
end

-- Create the command
vim.api.nvim_create_user_command("CMacroDel",
	function(opts)
		DeleteMacroFromClangd(CwordOrArgs(opts.args))
	end,
	{
		nargs = '?',
		desc = "Delete a macro definition from .clangd file",
		complete = function(ArgLead, CmdLine, CursorPos)
			local macros = GetAddedMacros()
			local matches = {}

			-- Filter macros based on what the user has typed so far
			for _, macro in ipairs(macros) do
				if macro:lower():find(ArgLead:lower(), 1, true) then
					table.insert(matches, macro)
				end
			end

			return matches
		end
	}
)


vim.keymap.set({ "n", "v" }, "<C-c><C-b>",
function()
	vim.cmd("Cscope db build")
	DefinedMacros = nil
	print("Invalidated DefinedMacros")
end
)
