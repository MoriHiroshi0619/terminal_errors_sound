#!/bin/bash

# Garante que o script está rodando no diretório correto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Executando uninstall.sh..."
bash "$SCRIPT_DIR/uninstall.sh"

echo "Executando initialize.sh..."
bash "$SCRIPT_DIR/initialize.sh"

echo "Atualização concluída com sucesso!"
