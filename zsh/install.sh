#!/usr/bin/env zsh

# Symlink the zsh/* files and top-level shared configs into $HOME.
# Run from anywhere: `zsh zsh/install.sh` or `./zsh/install.sh`.

set -euo pipefail

script_dir="${0:A:h}"           # absolute dir of this script
repo_dir="${script_dir:h}"      # one level up

link() {
	local src="$1" dst="$2"
	if [ -L "$dst" ] || [ -e "$dst" ]; then
		# Back up whatever is there, unless it's already the correct symlink.
		if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
			echo "ok   $dst"
			return
		fi
		mv "$dst" "$dst.backup.$(date +%s)"
		echo "back $dst -> $dst.backup.*"
	fi
	ln -s "$src" "$dst"
	echo "link $dst -> $src"
}

# Files sourced from $HOME
link "$script_dir/.zshrc"       "$HOME/.zshrc"
link "$script_dir/.zsh_prompt"  "$HOME/.zsh_prompt"
link "$script_dir/.aliases"     "$HOME/.aliases"
link "$script_dir/.exports"     "$HOME/.exports"
link "$script_dir/.functions"   "$HOME/.functions"

# Shell-agnostic configs from the repo root
link "$repo_dir/.gitconfig"     "$HOME/.gitconfig"
link "$repo_dir/.gitignore"     "$HOME/.gitignore"
link "$repo_dir/.gitattributes" "$HOME/.gitattributes"
link "$repo_dir/.inputrc"       "$HOME/.inputrc"
link "$repo_dir/.editorconfig"  "$HOME/.editorconfig"

echo
echo "Done. Start a new shell or run: exec zsh"
echo "For macOS defaults:  $repo_dir/.macos"
