export LAST_ERROR_SOUND=""

terminal_error_sound() {
    local ret=$?
    local event
    local dir

    (( ret == 0 )) && return

    # Diferencia Ctrl+C (SIGINT) de erros normais.
    if (( ret == 130 )); then
        event="INTERRUPT"
        dir="$HOME/.terminal-error-sounds/sounds/interrupt"
    else
        event="ERROR"
        dir="$HOME/.terminal-error-sounds/sounds/errors"
    fi

    # Suporta mp3, wav e ogg
    setopt localoptions nullglob
    local sounds=("$dir"/*.{mp3,wav,ogg}(N))

    (( ${#sounds[@]} == 0 )) && return

    local sound=${sounds[RANDOM % ${#sounds[@]} + 1]}

    # Evita repetir o mesmo som consecutivamente
    if (( ${#sounds[@]} > 1 )); then
        while [[ "$sound" == "$LAST_ERROR_SOUND" ]]; do
            sound=${sounds[RANDOM % ${#sounds[@]} + 1]}
        done
    fi

    LAST_ERROR_SOUND="$sound"

    if [[ "$TERMINAL_SOUNDS_DEBUG" == "true" ]]; then
        local cmd

        cmd=${history[$((HISTCMD-1))]}
        [[ -z "$cmd" ]] && cmd=$(fc -ln -1 2>/dev/null | sed -e 's/^[ \t]*//')

        echo "[DEBUG] CMD=$cmd" >&2
        echo "[DEBUG] EXIT_CODE=$ret" >&2
        echo "[DEBUG] EVENT=$event" >&2
        echo "[DEBUG] SOUND_DIR=$dir" >&2
        echo "[DEBUG] SOUND_FILE=${sound:t}" >&2
    fi

    (paplay "$sound" >/dev/null 2>&1 &) >/dev/null 2>&1
}

autoload -Uz add-zsh-hook 2>/dev/null || true

if type add-zsh-hook >/dev/null 2>&1; then
    add-zsh-hook precmd terminal_error_sound
else
    precmd_functions+=(terminal_error_sound)
fi
