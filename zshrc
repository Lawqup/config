# -*- mode: sh;-*-
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.cargo/bin:$HOME/bin:/usr/local/bin:$HOME/.local/share/gem/ruby/3.0.0/bin:$HOME/.ghcup/bin:$HOME/.local/bin:$HOME/config/scripts:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export EMAIL="lawrencequp@gmail.com"

NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# https://dev.to/kumareth/a-beginner-s-guide-for-setting-up-autocomplete-on-ohmyzsh-hyper-with-plugins-themes-47f2

plugins=(zsh-syntax-highlighting
         zsh-autosuggestions
         git
         colorize
         colored-man-pages
         sudo
         dirhistory
         web-search)

bindkey -M emacs '^S' sudo-command-line 
bindkey -M vicmd '^S' sudo-command-line 
bindkey -M viins '^S' sudo-command-line 

source $ZSH/oh-my-zsh.sh

# User configuration

export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='emacsclient'
else
	export EDITOR='emacsclient'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ctrl-z on the prompt will resume last
# This means, from vim I can ctrl-z to the shell, and ctrl-z back again.
foreground-last() {
  fg %
}
zle -N foreground-last
bindkey '^z' foreground-last


alias attu='cd &&  mkdir attu && sshfs quptylaw@attu.cs.washington.edu:/homes/iws/quptylaw ~/attu && cd ~/attu'

alias unattu='cd && umount attu &&  rm -r ~/attu'
# unmount force to kill
alias unattuf='cd && sudo umount -lf attu &&  rm -r ~/attu'

alias neofetch='neofetch --source ~/.config/neofetch/pictures/gigachad-ascii.txt'

# FZF

export FZF_DEFAULT_COMMAND="fd . $HOME --exclude={.git,Music,Videos,'VirtualBox VMs',Templates,.npm,.local,.tmux,.cache,.rustup,.ssh,.cargo} --type f -H"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_ALT_C_COMMAND="fd . $HOME --exclude={.git,Music,Videos,'VirtualBox VMs',Templates,.npm,.local,.tmux,.cache,.rustup,.ssh,.cargo} --type d -H"

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist/

NPM_PACKAGES="${HOME}/.npm-packages"

alias vim='nvim'
alias e='emacsclient --tty'
alias p='sudo pacman'

# if in tty, startx
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep xmonad || startx
fi

export NPM_PACKAGES="/home/lawrence/.npm-packages"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules${NODE_PATH:+:$NODE_PATH}"
export PATH="$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# bun completions
[ -s "/home/lawrence/.bun/_bun" ] && source "/home/lawrence/.bun/_bun"

# bun
export BUN_INSTALL="/home/lawrence/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Tell emacs vterm what a prompt is
# also allow directory tracking
if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi

emacs_vterm_prompt () {
    buffer_title_update=$(print -Pn "\e]2;%2~\a")
    pwd_update=$(print -Pn "\e]51;A$(whoami)@$(hostname):$(pwd)\e")
    prompt_end=$(print "%{$buffer_title_update$pwd_update%}\\")
    PROMPT="$PROMPT$prompt_end"
}
autoload -U add-zsh-hook
add-zsh-hook precmd emacs_vterm_prompt

alias ls="exa"
alias x="xdg-open"

export ALTERNATE_EDITOR=""

# Put a line between prompts, but not before the first
precmd() {
  precmd() {
    echo
  }
}

eval "$(starship init zsh)"
