# Needs to be already installed:
# - Git
# - iwd


echo "Installing programs"
sudo pacman -S zsh
sudo pacman -S emacs
sudo pacman -S rofi
sudo pacman -S alacritty
sudo pacman -S isync
sudo pacman -S flameshot
sudo pacman -S cron

echo "Installing XMonad and Haskell dependencies"
curl -sSL https://get.haskellstack.org/ | sh

mkdir ~/.xmonad
git -C ~/.xmonad/ clone https://github.com/xmonad/xmonad
git -C ~/.xmonad/ clone https://github.com/xmonad/xmonad-contrib
git -C ~/.xmonad/ clone https://codeberg.org/xmobar/xmobar

echo "Linking configs"
ln -fn ./xmonad.hs ~/.xmonad/xmonad.hs
ln -fn ./xmobarrc ~/.xmobarrc
ln -fn ./zshrc ~/.zshrc
ln -fn ./gitconfig ~/.gitconfig
ln -fn ./xinitrc ~/.xinitrc
ln -fn ./mbsyncrc ~/.mbsyncrc

mkdir ~/.config/rofi
ln -fn ./rofi.rasi ~/.config/rofi/config.rasi 

mkdir ~/.config/alacritty
ln -fn ./alacritty.yml ~/.config/alacritty/alacritty.yml

echo "Building XMonad"

(cd ~/.xmonad && stack init)
(cd ~/.xmonad && stack install)

echo "Restoring crontab"
crontab ./crontab

echo "Tangling emacs config"
emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "~/config/Emacs.org")'
