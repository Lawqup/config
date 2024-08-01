#!/usr/bin/env zsh

# Gets wifi strength
INTERFACE=wlp1s0

iwconfig $INTERFACE 2>&1 | grep -q no\ wireless\ extensions\. && {
  echo wired
  exit 0
}

essid=$(iwconfig $INTERFACE | awk -F '"' '/ESSID/ {print $2}')
stngth=$(iwconfig $INTERFACE | awk -F '=' '/Quality/ {print $2}' | cut -d ' ' -f 1)
[[ -z $stngth ]] && stngth='-1/1'
numer=$(($(echo $stngth | cut -d '/' -f 1) * 4))
denom=$(echo $stngth | cut -d '/' -f 2)
bars=$((($numer + $denom/2)/ $denom))  # Round to the nearest half

case $bars in
  0)  bar='⟨────⟩' ;;
  1)  bar='⟨/───⟩' ;;
  2)  bar='⟨//──⟩' ;;
  3)  bar='⟨///─⟩' ;;
  4)  bar='⟨////⟩' ;;
  *)  bar='⟨─!!─⟩' ;;
esac

echo "$essid <fc=#AAC0F0>$bar</fc>"

exit 0
