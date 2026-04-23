# Add `~/bin` and `~/.local/bin` to the `$PATH`
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,zsh_prompt,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=32768
SAVEHIST=32768
setopt APPEND_HISTORY         # append rather than overwrite
setopt INC_APPEND_HISTORY     # write as commands run
setopt HIST_IGNORE_DUPS       # don’t record duplicates in a row
setopt HIST_IGNORE_SPACE      # ignore commands starting with space
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY          # share history across sessions

# Directory navigation
setopt AUTO_CD                # `foo/bar` == `cd foo/bar`
setopt AUTO_PUSHD             # `cd` pushes to dir stack
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB          # extended globbing (equiv. bash globstar + more)

# Case-insensitive globbing
setopt NO_CASE_GLOB

# Correct typos in commands and paths
setopt CORRECT

# Completion
autoload -Uz compinit
# Only rebuild the dump once per day for faster startup.
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
	compinit
else
	compinit -C
fi

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# Colorize completion listings
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Menu select for tab completion
zstyle ':completion:*' menu select

# Homebrew completions, if present
if command -v brew >/dev/null 2>&1; then
	BREW_PREFIX="$(brew --prefix)"
	if [ -d "${BREW_PREFIX}/share/zsh/site-functions" ]; then
		fpath=("${BREW_PREFIX}/share/zsh/site-functions" $fpath)
	fi
	unset BREW_PREFIX
fi

# Tab-complete `g` as `git` (zsh picks this up from `_git` automatically via
# the alias, but set it explicitly to match the bash config intent).
if (( $+functions[_git] )); then
	compdef g=git
fi

# SSH hostname completion from ~/.ssh/config (wildcards ignored)
if [ -r "$HOME/.ssh/config" ]; then
	_ssh_hosts=(${(f)"$(grep '^Host' "$HOME/.ssh/config" | grep -v '[?*]' | cut -d ' ' -f2-)"})
	zstyle ':completion:*:(ssh|scp|sftp):*' hosts $_ssh_hosts
	unset _ssh_hosts
fi
