#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we're using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim
brew install grep
brew install openssh

# Install other useful binaries.
brew install git
brew install git-lfs
brew install imagemagick
brew install tree

# better git diffs
brew install delta

# GitHub CLI
brew install gh

# JSON processor
brew install jq

# Remove outdated versions from the cellar.
brew cleanup
