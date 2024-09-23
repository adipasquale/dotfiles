plugins=(rbenv poetry rails)
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

compresspdf() {
    for file in "$@"; do
        if [[ -f "$file" && "$file" == *.pdf ]]; then
            if [[ "$file" == *.compressed.pdf ]]; then
                echo "Skipping $file: Already compressed"
                continue
            fi
            output="${file%.pdf}.compressed.pdf"
            gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -dCompatibilityLevel=1.4 -sOutputFile="$output" "$file"
        else
            echo "Skipping $file: Not a PDF file"
        fi
    done
}

export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/postgresql@15/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@15/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@15/lib/pkgconfig"


alias ga='git add -p'
alias gcm='git commit -m'
alias gd='git diff'
alias gst='git status'
alias gco='git checkout'
alias gbr='git branch --remote'
alias gup='git pull --rebase'
alias gp='git push'

# cf https://www.atlassian.com/git/tutorials/dotfiles
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
