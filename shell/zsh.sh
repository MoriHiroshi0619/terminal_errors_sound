export LAST_ERROR_SOUND=""

terminal_error_sound() {
    local ret=$?

    (( ret == 0 )) && return

    local dir="$HOME/.terminal-error-sounds/sounds"

    # Suporta mp3, wav e ogg
    setopt localoptions nullglob
    local sounds=("$dir"/*.{mp3,wav,ogg}(N))

    (( ${#sounds[@]} == 0 )) && return

    local sound=${sounds[RANDOM % ${#sounds[@]} + 1]}

    # Garante que o próximo som seja diferente do último
    if (( ${#sounds[@]} > 1 )); then
        while [[ "$sound" == "$LAST_ERROR_SOUND" ]]; do
            sound=${sounds[RANDOM % ${#sounds[@]} + 1]}
        done
    fi
    LAST_ERROR_SOUND="$sound"

    (paplay "$sound" >/dev/null 2>&1 &) >/dev/null 2>&1
}

autoload -Uz add-zsh-hook 2>/dev/null || true
if type add-zsh-hook >/dev/null 2>&1; then
    add-zsh-hook precmd terminal_error_sound
else
    precmd_functions+=(terminal_error_sound)
fi
