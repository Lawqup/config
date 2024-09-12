local wezterm = require 'wezterm'
local mux = wezterm.mux

-- Decide whether cmd represents a default startup invocation
function is_default_startup(cmd)
   if not cmd then
      -- we were started with `wezterm` or `wezterm start` with
      -- no other arguments
      return true
   end
   if cmd.domain == "DefaultDomain" and not cmd.args then
      -- Launched via `wezterm start --cwd something`
      return true
   end
   -- we were launched some other way
   return false
end

wezterm.on('gui-startup', function(cmd)
              if is_default_startup(cmd) then
                 -- for the default startup case, we want to switch to the unix domain instead
                 local unix = mux.get_domain("unix")
                 mux.set_default_domain(unix)
                 -- ensure that it is attached
                 unix:attach()
              end
end)


local act = wezterm.action
return {
   color_scheme = 'Catppuccin Mocha',
   unix_domains = {
      { name = "unix" }
   },
   keys = {
      {
         key = 'x',
         mods = 'CMD | ALT ',
         action = wezterm.action.CloseCurrentTab { confirm = true },
      },

      { key = 'q', mods = 'CMD | ALT', action = wezterm.action.QuitApplication },
   --       {
   --          key = "-",
   --          mods = "ALT",
   --          action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
   --       },
   --       {
   --          key = "=",
   --          mods = "ALT",
   --          action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
   --       },
   --       {
   --          key = "x",
   --          mods = "ALT",
   --          action = act.CloseCurrentPane { confirm = false },
   --       },
   --       {
   --          key = 'o',
   --          mods = 'ALT',
   --          action = act.PaneSelect
   --       },
   },
   window_decorations = "RESIZE",
   enable_tab_bar = false
}
