# Needs to be already installed:
# - Git
# - XMonad (in .xmonad directory)
# - XMobar
# - iwd


echo "Installing programs"
sudo pacman -S zsh
sudo pacman -S emacs
sudo pacman -S rofi
sudo pacman -S alacritty
sudo pacman -S isync
sudo pacman -S flameshot

echo "Linking configs"
ln ~/.xmonad/xmonad.hs ./xmonad.hs
ln ~/.xmobarrc ./xmobarrc
ln ~/.zshrc ./zshrc
ln ~/.gitconfig ./gitconfig
ln ~/.xinitrc ./xinitrc
ln ~/.mbsyncrc ./mbsyncrc

mkdir ~/.config/rofi
ln ~/.config/rofi/config.rasi ./rofi.rasi

mkdir ~/.config/alacritty
ln ~/.config/alacritty/alacritty.yml ./alacritty.yml


echo "Restoring crontab"
crontab ./crontab

echo "Tangling emacs config"
emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "~/config/Emacs.org")'
