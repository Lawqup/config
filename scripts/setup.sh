RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

cd ~/config

alias p="sudo pacman -S --noconfirm"

echo -e "${GREEN}Installing Yay${NC}"

p --needed git base-devel
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay
makepkg -si

cd ~/config

echo -e "${GREEN}Installing programs${NC}"
sudo pacman -S zsh inetutils eza emacs rofi pacman-contrib\
  alacritty isync flameshot cron nitrogen\
  picom gcc cmake fd fzf opera wireless_tools\
  opera-ffmpeg-codecs alsa-utils xorg xorg-xinit\
  openssh ttf-nerd-fonts-symbols ttf-roboto\
  noto-fonts-emoji noto-fonts noto-fonts-extra\
  htop pulseaudio pulseaudio-alsa pulseaudio-bluetooth\
  bluez bluez-utils acpi dunst qalculate-gtk

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

curl -sS https://starship.rs/install.sh | sh

git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

yay -S --noconfirm lux

echo -e "${GREEN}Installing fonts${NC}"
p ttf-jetbrains-mono ttf-dejavu
yay -S --noconfirm tff-all-the-icons

echo -e "${GREEN}Installing XMonad and Haskell dependencies${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

mkdir ~/.xmonad
git -C ~/.xmonad/ clone https://github.com/xmonad/xmonad
git -C ~/.xmonad/ clone https://github.com/xmonad/xmonad-contrib
git -C ~/.xmonad/ clone https://codeberg.org/xmobar/xmobar

echo -e "${GREEN}Linking configs${NC}"
mkdir -p ~/.config
ln -fn ./xmonad.hs ~/.xmonad/xmonad.hs
ln -fn ./xmobarrc ~/.xmobarrc
ln -fn ./zshrc ~/.zshrc
ln -fn ./gitconfig ~/.gitconfig
ln -fn ./xinitrc ~/.xinitrc
ln -fn ./mbsyncrc ~/.mbsyncrc
ln -fn ./starship.toml ~/.config/starship.toml

(cd /etc/X11 && sudo ln -s ~/config/xorg.conf.d xorg.conf.d)

mkdir ~/.config/rofi
ln -fn ./rofi.rasi ~/.config/rofi/config.rasi 

mkdir ~/.config/alacritty
ln -fn ./alacritty.yml ~/.config/alacritty/alacritty.yml

mkdir ~/.config/dunst
ln -fn ./dunstrc ~/.config/dunst/dunstrc

echo -e "${GREEN}Building XMonad${NC}"

(cd ~/.xmonad &&\
     stack init --force &&\
     cp ~/config/scripts/xmonad_build_stack.yaml stack.yaml &&\
     stack install)

echo -e "${GREEN}Restoring crontab${NC}"
crontab ../crontab
systemctl enable --now cronie.service

echo -e "${GREEN}Tangling emacs config${NC}"
emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "~/config/Emacs.org")'
touch ~/.emacs.d/custom.el

echo -e "${GREEN}Setup completed${NC}"
echo -e "${GREEN}To set a wallpaper, run ${RED}nitrogen --set-zoom-fill --save /path/to/wallpaper${NC}"
