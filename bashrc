
########### BASH PROFILE, BASHRC resolve ###########
# if .bash_profile exists, add
# if [ -f ~/.bashrc ]; then
# 	source ~/.bashrc
# fi

########### CONDA env for BASH PROMPT ###########
# run `conda init` so that bash prompt shows conda environment
# `conda config --show | grep auto_activate_base` # check if it is True
# `conda config --set auto_activate_base False` # set to False


########### BASH PROMPT ###########
prompt_git() {
        local s=''
        local branchName=''

        # Check if the current directory is in a Git repository.
        git rev-parse --is-inside-work-tree &>/dev/null || return

        # Check for what branch we’re on.
        # Get the short symbolic ref. If HEAD isn’t a symbolic ref, get a
        # tracking remote branch or tag. Otherwise, get the
        # short SHA for the latest commit, or give up.
        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
                git describe --all --exact-match HEAD 2> /dev/null || \
                git rev-parse --short HEAD 2> /dev/null || \
                echo '(unknown)')"

        # Check for uncommitted changes in the index.
        if ! $(git diff --quiet --ignore-submodules --cached); then
            s+='+'
        fi
        # Check for unstaged changes.
        if ! $(git diff-files --quiet --ignore-submodules --); then
            s+='!'
        fi
        # Check for untracked files.
        if [ -n "$(git ls-files --others --exclude-standard)" ]; then
            s+='?'
        fi
        # Check for stashed files.
        if $(git rev-parse --verify refs/stash &>/dev/null); then
            s+='$'
        fi

        [ -n "${s}" ] && s="[${s}] "

        echo -e " ${s}(${branchName})"
}

export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH
export PROMPT_DIRTRIM=2
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w'
fi
PS1="$PS1\$(prompt_git)$ "

####### Prevent BYTECODE generation by Python Interpreter #######
export PYTHONDONTWRITEBYTECODE=1

####### Requires rg/ag and fzf ########
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

_has() {
  return $(type $1 &>/dev/null)
}

if _has fzf; then
  if _has rg; then
    SEARCH_PREFIX="rg --no-ignore --hidden --glob '!{.git,node_modules}/*'"
    FSEARCH_SUFFIX="--files 2>/dev/null"
  else
    SEARCH_PREFIX='ag --skip-vcs-ignores --hidden --ignore-dir={.git,node_modules}'
    FSEARCH_SUFFIX='-g "" 2>/dev/null'
  fi
  export FZF_DEFAULT_COMMAND="$SEARCH_PREFIX $FSEARCH_SUFFIX"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  # Nice little trick, without argument tries to locate the filename, with argument
  #          searches for the pattern in filecontents (and then for the filename)
  vimrg() {
    vim $(eval "$SEARCH_PREFIX --smart-case -l \"${@:-}\" | fzf --preview 'cat {}'")
  }
  # If more filecontent oriented search is required,
  #   use `vim -c "Rg"` or `vim -c "Ag"`, which is equivalent
  #   to opening vim and then executing the commands `:Rg` / `:Ag`
  #   shorthand: `vi -cRg`
fi

