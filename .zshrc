plugins=(poetry rails)
ZSH_THEME="amuse"
source ~/.oh-my-zsh/oh-my-zsh.sh

# show active gh user (yellow) after the git branch in the amuse theme prompt
gh_user_prompt_info() {
  local user=$(gh config get -h github.com user 2>/dev/null)
  [[ -n "$user" ]] && echo " %{$fg[yellow]%}gh:$user%{$reset_color%}"
}
PROMPT='
%{$fg_bold[green]%}%~%{$reset_color%}$(git_prompt_info)$(gh_user_prompt_info)$(virtualenv_prompt_info) ⌚ %{$fg_bold[red]%}%*%{$reset_color%}
$ '

alias ga='git add -p'
alias gs='git status'
alias gc='git checkout'
alias gpull='git pull --rebase'
alias gpush='git push'
alias gb="git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads |  head -n 8"

git_dig () {
    git log --pretty=format:'%Cred%h%Creset - %Cgreen(%ad)%Creset - %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=short -G"$1" -- $2
}

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

export EDITOR=nvim

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias ber='bundle exec rspec'

export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq@16/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@8.4/bin:$PATH"

alias cdr="cd ~/dev/rdv-service-public"

# cf https://www.wrenhold.com/posts/2023/setup-dotfiles-git/#downloading-your-repository-onto-a-new-machine
export DOTFILES_PATH=~/.dotfilesgit
alias dotfilesgit='/usr/bin/git --git-dir=$DOTFILES_PATH/ --work-tree=$HOME'

# Mise is a version manager for node, ruby, go, python... replaces rbenv pyenv etc
eval "$(mise activate zsh)"

export POSTGRES_USER=adipasquale

export EUROUTER_API_KEY=$(security find-generic-password -a "$USER" -s "kilo-eurouter-api-key" -w 2>/dev/null)

source ~/.zsh/completion/scalingo_complete.zsh

# smolvm
export PATH="/Users/adrienbetagouv/.local/bin:$PATH"
