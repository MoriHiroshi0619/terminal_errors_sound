export LAST_ERROR_SOUND=""

terminal_error_sound() {
    local ret=$?

    (( ret == 0 )) && return

    local dir="$HOME/.terminal-error-sounds/sounds"

    mapfile -t sounds < <(
        find "$dir" \
            -maxdepth 1 \
            -type f \
            \( -name '*.mp3' -o -name '*.wav' -o -name '*.ogg' \)
    )

    (( ${#sounds[@]} == 0 )) && return

    local sound="${sounds[$((RANDOM % ${#sounds[@]}))]}"

    if (( ${#sounds[@]} > 1 )); then
        while [[ "$sound" == "$LAST_ERROR_SOUND" ]]; do
            sound="${sounds[$((RANDOM % ${#sounds[@]}))]}"
        done
    fi

    LAST_ERROR_SOUND="$sound"

    (paplay "$sound" >/dev/null 2>&1 &) >/dev/null 2>&1
}


if declare -F blehook >/dev/null; then
    blehook POSTEXEC+=terminal_error_sound
else
    PROMPT_COMMAND+=(terminal_error_sound)
fi
