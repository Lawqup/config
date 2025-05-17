# Remove options from before
set -x

setxkbmap us
setxkbmap -option

internal_id=$(
    xinput list |
    sed -n 's/.*AT Translated.*id=\([0-9]*\).*keyboard.*/\1/p' | head -n 1
)
if [ "$internal_id" ]; then
	setxkbmap -device $internal_id -option ctrl:swapcaps
fi

glove80_id=$(
    xinput list |
    sed -n 's/.*Glove80.*id=\([0-9]*\).*keyboard.*/\1/p' | head -n 1
)
if [ "$glove80_id" ]; then
	setxkbmap -device $glove80_id -option
fi


wave75_id=$(
    xinput list |
    sed -n 's/.*WAVE 75 RGB Keyboard.*id=\([0-9]*\).*keyboard.*/\1/p' | head -n 1
)
if [ "$wave75_id" ]; then
	setxkbmap -device $wave75_id -option ctrl:swapcaps
fi
