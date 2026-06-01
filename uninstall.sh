#!/usr/bin/env bash

set -e

for file in "$HOME/.bashrc" "$HOME/.zshrc"
do
    [ -f "$file" ] || continue

    sed -i '\|# terminal-error-sounds|d' "$file"
    sed -i '\|source "$HOME/.terminal-error-sounds/bash.sh"|d' "$file"
    sed -i '\|source "$HOME/.terminal-error-sounds/zsh.sh"|d' "$file"
done

rm -rf "$HOME/.terminal-error-sounds"

echo "Desinstalação concluída."
