#!/bin/zsh

# Gets wifi strength

iwconfig wlan0 2>&1 | grep -q no\ wireless\ extensions\. && {
  echo wired
  exit 0
}

essid=$(iwconfig wlan0 | awk -F '"' '/ESSID/ {print $2}')
stngth=$(iwconfig wlan0 | awk -F '=' '/Quality/ {print $2}' | cut -d ' ' -f 1)
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

echo $essid $bar

exit 0
