# Terminal Error Sounds

Este projeto permite reproduzir um som aleatório sempre que um comando falhar no terminal (retornar um código de saída diferente de zero) ou for interrompido pelo usuário (pressionando `Ctrl + C`).

## Funcionalidades
- Suporte para Bash e Zsh
- Diferencia falhas reais de execuções interrompidas (`Ctrl + C`)
- Pastas de áudio separadas para erros e interrupções
- Instalação e desinstalação automatizadas
- Impede a repetição do mesmo som consecutivamente
- Silencia mensagens de background (jobs) no terminal
- Suporta arquivos `.mp3`, `.wav` e `.ogg`

## Requisitos
O projeto utiliza o comando `paplay` para tocar o áudio no Linux (PulseAudio/PipeWire).
Caso não tenha instalado, instale com:
```bash
sudo apt install pulseaudio-utils
```
*(O instalador verificará essa dependência automaticamente).*

## Mudar efeitos sonoros
Basta adicionar/remover os efeitos sonoros salvos nas respectivas pastas após a instalação:
- `~/.terminal-error-sounds/sounds/errors/` para sons tocados quando comandos falham.
- `~/.terminal-error-sounds/sounds/interrupt/` para sons tocados ao interromper com `Ctrl + C`. 

## Instalação
Clone este repositório e execute o script de inicialização:
```bash
./initialize.sh
```
Após a instalação, recarregue seu terminal:
```bash
source ~/.bashrc # para Bash
# ou
source ~/.zshrc # para Zsh
```

## Atualização
Para atualizar o utilitário com novos scripts ou arquivos baixados do repositório, execute o script de atualização:
```bash
./update.sh
```
Isso desinstalará a versão anterior e fará uma instalação limpa automaticamente.

## Desinstalação
Para remover o utilitário, basta executar o script de desinstalação:
```bash
./uninstall.sh
```
Isso removerá a pasta de arquivos e limpará a linha adicionada ao arquivo `.bashrc` ou `.zshrc`.

## Debug
Caso queira visualizar informações detalhadas sobre a execução e a escolha dos áudios, você pode ativar o modo de debug exportando a seguinte variável:
```bash
export TERMINAL_SOUNDS_DEBUG=true
```
Isso fará com que o script exiba logs com o comando executado, exit code, evento identificado e arquivo de áudio tocado.

## Gostou da ideia?

Este repo nasceu porque eu achei engraçado transformar erros do terminal em momentos de entretenimento.

Se você também acha que uma mensagem de erro fica melhor acompanhada de um meme sonoro, fique à vontade para usar, adaptar e adicionar seus próprios áudios.

E se o projeto arrancou uma risada ou foi útil para você, deixe uma ⭐ no repositório para fortalecer. Afinal, manter a seriedade no terminal é opcional.

<p align="center">
  <img src="./hackerman.gif" alt="Hackerman em ação" width="800">
</p>