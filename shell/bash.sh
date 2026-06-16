export LAST_ERROR_SOUND=""
export _TERMINAL_SOUNDS_INTERRUPTED=0

_terminal_sounds_sigint_handler() {
    _TERMINAL_SOUNDS_INTERRUPTED=1
    trap - INT
    kill -INT $$ 2>/dev/null || true
}
trap '_terminal_sounds_sigint_handler' INT

terminal_error_sound() {
    local ret=$?
    
    # Garantir que o trap continue ativo para o próximo comando
    trap '_terminal_sounds_sigint_handler' INT

    local event
    local dir

    # Lógica para diferenciar erro real de interrupção (Ctrl+C)
    if [[ "$_TERMINAL_SOUNDS_INTERRUPTED" == "1" ]]; then
        event="INTERRUPT"
        dir="$HOME/.terminal-error-sounds/sounds/interrupt"
    else
        (( ret == 0 )) && return
        event="ERROR"
        dir="$HOME/.terminal-error-sounds/sounds/errors"
    fi

    # Limpar a flag após tratar o evento
    _TERMINAL_SOUNDS_INTERRUPTED=0

    mapfile -t sounds < <(
        find "$dir" \
            -maxdepth 1 \
            -type f \
            \( -name '*.mp3' -o -name '*.wav' -o -name '*.ogg' \) 2>/dev/null
    )

    (( ${#sounds[@]} == 0 )) && return

    local sound="${sounds[$((RANDOM % ${#sounds[@]}))]}"

    if (( ${#sounds[@]} > 1 )); then
        while [[ "$sound" == "$LAST_ERROR_SOUND" ]]; do
            sound="${sounds[$((RANDOM % ${#sounds[@]}))]}"
        done
    fi

    LAST_ERROR_SOUND="$sound"

    if [[ "$TERMINAL_SOUNDS_DEBUG" == "true" ]]; then
        if [[ "$event" == "ERROR" ]]; then
            local cmd=$(history 1 | sed -e 's/^[ ]*[0-9]\+[ ]*//')
            echo "[DEBUG] CMD=$cmd" >&2
            echo "[DEBUG] EXIT_CODE=$ret" >&2
        else
            echo "[DEBUG] SIGINT_RECEIVED" >&2
        fi
        echo "[DEBUG] EVENT=$event" >&2
        echo "[DEBUG] SOUND_DIR=$dir" >&2
        echo "[DEBUG] SOUND_FILE=$(basename "$sound")" >&2
    fi

    (paplay "$sound" >/dev/null 2>&1 &) >/dev/null 2>&1
}


if declare -F blehook >/dev/null; then
    blehook POSTEXEC+=terminal_error_sound
else
    PROMPT_COMMAND+=(terminal_error_sound)
fi
