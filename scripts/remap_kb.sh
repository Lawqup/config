# Remove options from before
set -x

setxkbmap us
setxkbmap -option

internal_id=$(
    xinput list |
    sed -n 's/.*AT Translated.*id=\([0-9]*\).*keyboard.*/\1/p'
)
[ "$internal_id" ] || exit 0

setxkbmap -device $internal_id -option ctrl:swapcaps

external_id=$(
    xinput list |
    sed -n 's/.*Glove80.*id=\([0-9]*\).*keyboard.*/\1/p'
)
[ "$external_id" ] || exit 0

setxkbmap -device $external_id -option
