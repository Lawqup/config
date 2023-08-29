RED='\033[1;31m'
GREEN='\033[1;32m'
cd ~/config

echo -e "${GREEN}Installing programs"
sudo pacman -S zsh inetutils exa emacs rofi\
     alacritty isync flameshot cron nitrogen\
     picom gcc cmake fd fzf opera wireless_tools

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo -e "${GREEN}Installing fonts"
sudo pacman -S ttf-jetbrains-mono ttf-dejavu

echo -e "${GREEN}Installing XMonad and Haskell dependencies"
curl -sSL https://get.haskellstack.org/ | sh

mkdir ~/.xmonad
git -C ~/.xmonad/ clone https://github.com/xmonad/xmonad
git -C ~/.xmonad/ clone https://github.com/xmonad/xmonad-contrib
git -C ~/.xmonad/ clone https://codeberg.org/xmobar/xmobar

echo -e "${GREEN}Linking configs"
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

echo -e "${GREEN}Building XMonad"

(cd ~/.xmonad &&\
     stack init &&\
     cp ~/config/scripts/xmonad_build_stack.yaml stack.yaml &&\
     stack install)

echo -e "${GREEN}Restoring crontab"
crontab ./crontab

echo -e "${GREEN}Tangling emacs config"
emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "~/config/Emacs.org")'
touch ~/.emacs.d/custom.el

echo -e "${GREEN}Setup completed"
echo -e "${GREEN}To set a wallpaper, run ${RED}nitrogen --set-zoom-fill --save /path/to/wallpaper"
