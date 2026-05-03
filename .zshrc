plugins=(rbenv poetry rails forgit)
ZSH_THEME="amuse"
source ~/.oh-my-zsh/oh-my-zsh.sh

eval "$(rbenv init - zsh)"

alias termconfig="code ~/.zshrc"
alias termreload="source ~/.zshrc"

function co() {
  gh copilot suggest -t shell "$@"
}

# PYENV
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


alias ga='git add -p'
alias gcommitm='git commit -m'
alias gd='git diff'
alias gs='git status'
alias gc='git checkout'
alias gpull='git pull --rebase'
alias gpush='git push'
alias gb="git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads |  head -n 8"

. "/Users/adipasquale/.deno/env"


git_dig () {
    git log --pretty=format:'%Cred%h%Creset - %Cgreen(%ad)%Creset - %s %C(bold blue)<%an>%Creset' --abbrev-commit --date=short -G"$1" -- $2
}

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

alias config='/usr/bin/git --git-dir=/Users/adipasquale/.cfg/ --work-tree=/Users/adipasquale'

export EDITOR=nvim

# bun completions
[ -s "/Users/adipasquale/.bun/_bun" ] && source "/Users/adipasquale/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias ber='bundle exec rspec'

export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq@16/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@8.4/bin:$PATH"

export PHPENV_ROOT="/Users/adipasquale/.phpenv"
if [ -d "${PHPENV_ROOT}" ]; then
  export PATH="${PHPENV_ROOT}/bin:${PATH}"
  eval "$(phpenv init -)"
fi
