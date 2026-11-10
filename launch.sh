#!/bin/sh

PAK_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$PAK_DIR" || exit 1

HOME="$PAK_DIR"
export HOME

export SDL_NOMOUSE=1
export SDL_AUDIODRIVER=alsa

chmod +x "$PAK_DIR/butterscotch"

SAVE_DIR="$SAVES_PATH/Downwell"
[ -n "$SAVES_PATH" ] || SAVE_DIR="$PAK_DIR/saves"

mkdir -p "$SAVE_DIR"

# CPU performance boost
overclock.elf $CPU_SPEED_PERF 2>/dev/null

for i in 0 1 2 3; do
    echo performance > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor 2>/dev/null
done

restore_cpu() {
    for i in 0 1 2 3; do
        echo userspace > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor 2>/dev/null
        echo 504000 > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_setspeed 2>/dev/null
    done
}

trap restore_cpu EXIT

sleep 1

./butterscotch \
    --gui-ratio=4:3 \
    --lazy-rooms \
    --lazy-audio \
    --lazy-textures \
    --disable-log-colors \
    --save-folder "$SAVE_DIR/" \
    data.win > ./debug.log 2>&1

RET=$?
echo "Exit code: $RET" >> ./debug.log

exit $RET
