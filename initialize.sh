#!/usr/bin/env bash

set -e

# Verificar dependência
if ! command -v paplay >/dev/null 2>&1; then
    echo "paplay não encontrado."
    echo ""
    echo "Instale:"
    echo "sudo apt install pulseaudio-utils"
    exit 1
fi

INSTALL_DIR="$HOME/.terminal-error-sounds"

mkdir -p "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR/sounds/errors"
mkdir -p "$INSTALL_DIR/sounds/interrupt"

cp shell/bash.sh "$INSTALL_DIR/"
cp shell/zsh.sh "$INSTALL_DIR/"

# Copiar sons apenas se existirem
if [ -d "sounds/errors" ] && [ "$(ls -A sounds/errors 2>/dev/null)" ]; then
    cp -r sounds/errors/* "$INSTALL_DIR/sounds/errors/"
fi

if [ -d "sounds/interrupt" ] && [ "$(ls -A sounds/interrupt 2>/dev/null)" ]; then
    cp -r sounds/interrupt/* "$INSTALL_DIR/sounds/interrupt/"
fi


SHELL_TYPE=$(basename "$SHELL")

case "$SHELL_TYPE" in
    bash)
        RC_FILE="$HOME/.bashrc"
        SOURCE_LINE='source "$HOME/.terminal-error-sounds/bash.sh"'
        ;;
    zsh)
        RC_FILE="$HOME/.zshrc"
        SOURCE_LINE='source "$HOME/.terminal-error-sounds/zsh.sh"'
        ;;
    *)
        echo "Shell não suportado: $SHELL_TYPE"
        exit 1
        ;;
esac

if ! grep -Fq "$SOURCE_LINE" "$RC_FILE" 2>/dev/null; then
    echo "" >> "$RC_FILE"
    echo "# terminal-error-sounds" >> "$RC_FILE"
    echo "$SOURCE_LINE" >> "$RC_FILE"
fi

echo "Instalação concluída."
echo "Reabra o terminal ou execute:"
echo "source $RC_FILE"
