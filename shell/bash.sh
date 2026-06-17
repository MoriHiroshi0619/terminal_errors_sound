export LAST_ERROR_SOUND=""

terminal_error_sound() {
    local ret=$?
    local event
    local dir

    (( ret == 0 )) && return

    # 130 = processo interrompido por SIGINT (Ctrl+C)
    if (( ret == 130 )); then
        event="INTERRUPT"
        dir="$HOME/.terminal-error-sounds/sounds/interrupt"
    else
        event="ERROR"
        dir="$HOME/.terminal-error-sounds/sounds/errors"
    fi

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
        local cmd
        cmd=$(history 1 | sed -e 's/^[ ]*[0-9]\+[ ]*//')

        echo "[DEBUG] CMD=$cmd" >&2
        echo "[DEBUG] EXIT_CODE=$ret" >&2
        echo "[DEBUG] EVENT=$event" >&2
        echo "[DEBUG] SOUND_DIR=$dir" >&2
        echo "[DEBUG] SOUND_FILE=$(basename "$sound")" >&2
    fi

    (paplay "$sound" >/dev/null 2>&1 &) >/dev/null 2>&1
}

if declare -F blehook >/dev/null; then
    blehook POSTEXEC+=terminal_error_sound
else
    if declare -p PROMPT_COMMAND 2>/dev/null | grep -q 'declare \-a'; then
        PROMPT_COMMAND+=(terminal_error_sound)
    else
        PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }terminal_error_sound"
    fi
fi