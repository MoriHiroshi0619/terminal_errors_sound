export LAST_ERROR_SOUND=""

terminal_error_sound() {
    local ret=$?

    [ "$ret" -eq 0 ] && return

    local dir="$HOME/.terminal-error-sounds/sounds"

    # Suporta mp3, wav e ogg (conforme especificações futuras)
    mapfile -t sounds < <(
        find "$dir" \
            -maxdepth 1 \
            -type f \
            \( -name '*.mp3' -o -name '*.wav' -o -name '*.ogg' \)
    )

    [ ${#sounds[@]} -eq 0 ] && return

    local sound="${sounds[$((RANDOM % ${#sounds[@]}))]}"

    # Garante que o próximo som seja diferente do último
    if [ ${#sounds[@]} -gt 1 ]; then
        while [ "$sound" = "$LAST_ERROR_SOUND" ]; do
            sound="${sounds[$((RANDOM % ${#sounds[@]}))]}"
        done
    fi
    LAST_ERROR_SOUND="$sound"

    (paplay "$sound" >/dev/null 2>&1 &) >/dev/null 2>&1
}

PROMPT_COMMAND="terminal_error_sound"
