# Remove options from before
setxkbmap us
setxkbmap -option

internal_id=$(
    xinput list |
    sed -n 's/.*AT Translated.*id=\([0-9]*\).*keyboard.*/\1/p'
)
[ "$internal_id" ] || exit

external_id=$(
    xinput list |
    sed -n 's/.*Glove80.*id=\([0-9]*\).*keyboard.*/\1/p'
)
[ "$external_id" ] || exit

# xinput --create-master "External"

# external_master_id=$(
#     xinput list |
#     sed -n 's/.*External.*id=\([0-9]*\).*keyboard.*/\1/p'
# )
# [ "$external_master_id" ] || exit

# xinput --reattach $external_id $external_master_id


setxkbmap -device $internal_id -option ctrl:swapcaps
setxkbmap -device $external_id -option
