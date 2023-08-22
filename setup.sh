# Needs to be already installed:
# - Git
# - iwd


echo "Installing programs"
sudo pacman -S zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo pacman -S inetutils  # "hostname" command
sudo pacman -S exa
sudo pacman -S emacs
sudo pacman -S rofi
sudo pacman -S alacritty
sudo pacman -S isync
sudo pacman -S flameshot
sudo pacman -S cron
sudo pacman -S nitrogen
sudo pacman -S picom

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
