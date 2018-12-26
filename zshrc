#!/usr/bin/env zsh

export DOTFILES=$HOME/.dotfiles
export INCLUDES=$HOME/.local/share/dotfiles

export MPLCONFIGDIR=$DOTFILES/mplconfigdir

source $DOTFILES/aliases

eval `dircolors $DOTFILES/dircolors`

#source $INCLUDES/zsh-completions/zsh-completions.plugin.zsh
#source $INCLUDES/zsh-history-substring-search/zsh-history-substring-search.zsh
#source $INCLUDES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

autoload -U compinit && compinit
zmodload -i zsh/complist

unsetopt menu_complete
unsetopt flowcontrol

setopt prompt_subst
setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt interactivecomments
setopt share_history

# The following assumes a conda installation. This is the standard code that would be installed
# by the conda installer during setup.
__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/bthorne/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/home/bthorne/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/bthorne/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/home/bthorne/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# set keybindings to emacs style
bindkey -e

git_prompt() {
  BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/*\(.*\)/\1/')

  if [ ! -z $BRANCH ]; then
    echo -n "%F{yellow}$BRANCH"

    if [ ! -z "$(git status --short)" ]; then
      echo " %F{red}✗"
    fi
  fi
}


PS1='
%~$(git_prompt)
%F{244}%# %F{reset}'

source $HOME/.fzf.zsh
