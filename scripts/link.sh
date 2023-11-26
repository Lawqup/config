DIR="${HOME}/config"

mkdir -p ~/.config
ln -fnv "${DIR}/xmonad.hs" ~/.xmonad/xmonad.hs
ln -fnv "${DIR}/xmobarrc" ~/.xmobarrc
ln -fnv "${DIR}/zshrc" ~/.zshrc
ln -fnv "${DIR}/gitconfig" ~/.gitconfig
ln -fnv "${DIR}/xinitrc" ~/.xinitrc
ln -fnv "${DIR}/mbsyncrc" ~/.mbsyncrc
ln -fnv "${DIR}/starship.toml" ~/.config/starship.toml

(cd /etc/X11 && sudo ln -s ~/config/xorg.conf.d xorg.conf.d)

mkdir -p ~/.config/rofi
ln -fnv "${DIR}/rofi.rasi" ~/.config/rofi/config.rasi 

mkdir -p ~/.config/alacritty
ln -fnv "${DIR}/alacritty.yml" ~/.config/alacritty/alacritty.yml

mkdir -p ~/.config/dunst
ln -fnv "${DIR}/dunstrc" ~/.config/dunst/dunstrc
