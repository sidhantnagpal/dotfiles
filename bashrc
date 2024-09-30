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

export PROMPT_DIRTRIM=2
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w'
fi
PS1="$PS1\$(prompt_git)$ "


####### Prevent BYTECODE generation by Python Interpreter #######
export PYTHONDONTWRITEBYTECODE=1


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE="$HOME/.local/bin/micromamba";
export MAMBA_ROOT_PREFIX="$HOME/micromamba";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

##### For micromamba and toolenv ######
alias mm=micromamba

# Append 'toolenv' bin to PATH (if it isnt already added).
# The trailing forward slash after bin/ is intentional to
# retain it in PATH even after toolenv is deactivated.
# This is needed because env activation adds a new entry
# without forward slash for bin in PATH and deactivation
# removes all entries without forward slash.
TOOLENV_PATH="$MAMBA_ROOT_PREFIX/envs/toolenv/bin"
if [[ ":$PATH:" != *":$TOOLENV_PATH:"* ]]; then
    export PATH="$TOOLENV_PATH:$PATH"
fi
unset TOOLENV_PATH


####### Requires rg/ag and fzf ########
_has() {
  return $(type $1 &>/dev/null)
}

if _has fzf; then
  # Check if rg is present otherwise try to use ag.
  #	    Doesn't follow symlinks by default (add --follow after --hidden in both rg / ag commands to do so).
  if _has rg; then
    SEARCH_PREFIX="rg --no-ignore --hidden --glob '!{.git,node_modules}/*'"
    FSEARCH_SUFFIX="--files 2>/dev/null"
  else
    SEARCH_PREFIX='ag --skip-vcs-ignores --hidden --ignore-dir={.git,node_modules}'
    FSEARCH_SUFFIX='-g "" 2>/dev/null'
  fi

  export FZF_DEFAULT_COMMAND="$SEARCH_PREFIX $FSEARCH_SUFFIX"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  # setup shell bindings for fzf
  eval "$(fzf --bash)"

  # If file content (or name) oriented search is required,
  #   use `vim -c "Rg"` or `vim -c "Ag"`, which is equivalent
  #   to opening vim and then executing the commands `:Rg` / `:Ag`.
  #   Shorthand: `vi -cRg`. These need fzf.vim plugin!

  # vim global search alias - open vim with fuzzy search filename/content
  alias vig='vim -cRg'   # equivalent to doing vim + leader key + g
  # vim history alias - open vim with fuzzy search "recently opened files"
  alias vih='vim -cHist' # equivalent to doing vim + leader key + h

  unset SEARCH_PREFIX
  unset FSEARCH_SUFFIX
fi

if _has rg; then
  rgg() {
    git ls-files -z | xargs -0 rg "$@"
  }
fi

unset -f _has
