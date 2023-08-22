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
git clone https://github.com/xmonad/xmonad ~/.xmonad
git clone https://github.com/xmonad/xmonad-contrib ~/.xmonad
git clone https://codeberg.org/xmobar/xmobar ~/.xmonad

echo "Linking configs"
ln ./xmonad.hs ~/.xmonad/xmonad.hs
ln ./xmobarrc ~/.xmobarrc
ln ./zshrc ~/.zshrc
ln ./gitconfig ~/.gitconfig
ln ./xinitrc ~/.xinitrc
ln ./mbsyncrc ~/.mbsyncrc

mkdir ~/.config/rofi
ln ~/.config/rofi/config.rasi ./rofi.rasi

mkdir ~/.config/alacritty
ln ~/.config/alacritty/alacritty.yml ./alacritty.yml


echo "Restoring crontab"
crontab ./crontab

echo "Tangling emacs config"
emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "~/config/Emacs.org")'
