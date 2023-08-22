# Needs to be already installed:
# - Git
# - iwd


echo "Installing programs"
sudo pacman -S zsh inetutils exa emacs rofi\
     alacritty isync flameshot cron nitrogen\
     picom gcc cmake

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing fonts"
sudo pacman -S ttf-jetbrains-mono ttf-dejavu

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
touch ~/.emacs.d/custom.el

