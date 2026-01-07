alias ll='ls -laG'
alias reload='source ~/.zprofile && source ~/.zshrc'
alias gs='git status'
alias vi='nvim'

autoload -Uz vcs_info
source ~/.dotfiles/zsh-autosuggestions/zsh-autosuggestions.zsh

precmd() {
    vcs_info
}

# Enable checking for (un)staged changes
zstyle ':vcs_info:*' check-for-changes true

# Define symbols for staged (+) and unstaged (*) changes
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:*' unstagedstr ' *'

# %b expands to the branch name
# %c expands to stagedstr (if changes exist)
# %u expands to unstagedstr (if changes exist)
# We add " | " inside the format string so the pipe only shows when a git repo is detected
zstyle ':vcs_info:git:*' formats ' | %b%c%u'
zstyle ':vcs_info:*' enable git

# Enable variable substitution in the prompt
setopt PROMPT_SUBST

# %D{%Y-%m-%dT%H-%M}  : Date/Time in format yyyy-mm-ddThh-mm
# ${vcs_info_msg_0_}  : The git branch info (includes pipe, branch, and status)
# $'\n'               : Newline character
# %B%~%b              : Current working directory (Bold) relative to ~
# %#                  : The prompt character (% for user, # for root)
PROMPT='%D{%Y-%m-%dT%H-%M}${vcs_info_msg_0_}'$'\n''%B%~%b %# '

# 6. History Configuration
# Keep more history and save it to a file
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Options for better history management
setopt APPEND_HISTORY       # Append to history file immediately, don't overwrite
setopt SHARE_HISTORY        # Share history between different terminal tabs instantly
setopt HIST_IGNORE_DUPS     # Don't record an entry that was just recorded
setopt HIST_IGNORE_SPACE    # Don't record commands starting with a space (useful for secrets)

# 7. Navigation & Usability
setopt AUTO_CD              # If you type a folder name (without cd), go there
setopt CORRECT              # Auto-correct simple command spelling errors

# 8. Completion System
# Initialize the advanced completion system
autoload -Uz compinit
compinit

# Case insensitive tab completion (e.g., type 'cd doc' -> matches 'Documents')
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Use the same colors as 'ls' for the completion menu
zstyle ':completion:*' list-colors ''

# 9. Keybindings (History Search)
# This allows you to type "git" and hit Up Arrow to see only your past git commands
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search   # Up Arrow
bindkey "^[[B" down-line-or-beginning-search # Down Arrow

export EDITOR=nvim
export PATH="$PATH:$HOME/Programming/gila/zig-out/bin/"
export PATH="$HOME/.local/bin:$PATH"
