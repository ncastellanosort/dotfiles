#!/bin/bash
# Controla el volumen del sink fisico (hardware), no el de easyeffects_sink.
# Uso: volume.sh up|down|mute|status
# "status" imprime el texto para el modulo custom/volume de Waybar.

SINK=$(pactl list short sinks | awk '$2 ~ /^alsa_output\./ {print $2; exit}')
[ -z "$SINK" ] && exit 1

case "$1" in
    up)
        cur=$(pactl get-sink-volume "$SINK" | grep -oE '[0-9]+%' | head -1 | tr -d '%')
        new=$((cur + 5))
        [ "$new" -gt 100 ] && new=100
        pactl set-sink-volume "$SINK" "${new}%"
        ;;
    down)
        pactl set-sink-volume "$SINK" -5%
        ;;
    mute)
        pactl set-sink-mute "$SINK" toggle
        ;;
    status)
        if pactl get-sink-mute "$SINK" | grep -q yes; then
            echo "VOL MUT"
        else
            vol=$(pactl get-sink-volume "$SINK" | grep -oE '[0-9]+%' | head -1)
            echo "VOL $vol"
        fi
        exit 0
        ;;
esac

# Refrescar Waybar (modulo custom/volume, signal 8)
pkill -RTMIN+8 waybar
