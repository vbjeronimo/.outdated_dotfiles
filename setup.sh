#!/bin/bash

set -e

DOTFILES_URL="https://github.com/vbjeronimo/.dotfiles.git"
WALLPAPER_URL="https://w.wallhaven.cc/full/9m/wallhaven-9mjoy1.png"
LIGHTDM_GREETER="lightdm-gtk-greeter"
USERNAME="$USER"

echo "[*] Updating the system..."
sudo pacman -Syu --noconfirm

echo "[*] Installing base dependencies..."
sudo pacman -S --noconfirm --needed wget curl sed zip unzip openssh git

echo "[*] Installing video drivers..."
if lspci | grep -q "NVIDIA"; then
    sudo pacman -S --noconfirm --needed nvidia nvidia-utils nvidia-settings
elif lspci | grep -q "AMD"; then
    sudo pacman -S --noconfirm --needed xf86-video-amdgpu
elif lspci | grep -q "Intel"; then
    sudo pacman -S --noconfirm --needed xf86-video-intel
fi

echo "[*] Installing display manager..."
sudo pacman -S --noconfirm --needed lightdm "$LIGHTDM_GREETER"
sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=$LIGHTDM_GREETER/" /etc/lightdm/lightdm.conf
sudo systemctl enable lightdm.service

echo "[*] Installing graphical environment..."
sudo pacman -S --noconfirm --needed i3-gaps i3status dunst rofi papirus-icon-theme autorandr

echo "[*] Installing more stuff..."
sudo pacman -S --noconfirm --needed \
    kitty starship fzf \
    pass stow exa bat feh xclip playerctl xorg-xev \
    ttf-firacode-nerd ttf-liberation ttf-dejavu ttf-ubuntu-font-family noto-fonts-emoji \
    firefox thunderbird discord obsidian

if [ "$(basename "$SHELL")" != "fish" ]; then
    echo "[*] Setting default shell to fish..."
    sudo pacman -S --noconfirm --needed fish
    sudo chsh -s /bin/fish "$USERNAME"
fi

echo "[*] Installing NetworkManager..."
sudo pacman -S --noconfirm --needed networkmanager network-manager-applet
sudo systemctl enable NetworkManager.service

echo "[*] Installing Neovim..."
sudo pacman -S --noconfirm --needed neovim fd ripgrep luarocks npm python-pip shellcheck

echo "[*] Installing Tmux..."
sudo pacman -S --noconfirm --needed tmux
if [[ ! -e ~/.tmux/plugins/tpm ]]; then
    echo "[*] Cloning Tmux Package Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "[*] Installing Docker..."
sudo pacman -S --noconfirm --needed docker
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo usermod -aG docker "$USERNAME"

echo "[*] Installing UFW..."
sudo pacman -S --noconfirm --needed ufw
sudo systemctl enable ufw.service
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

echo "[*] Installing Syncthing..."
sudo pacman -S --noconfirm --needed syncthing
systemctl --user enable syncthing.service

echo "[*] Installing virt-manager..."
sudo pacman -S --noconfirm --needed qemu libvirt virt-manager dnsmasq
sudo systemctl enable libvirtd.service
sudo usermod -aG libvirt "$USERNAME"

echo "[*] Installing python development tools..."
echo "[*][*] Installing pyenv..."
# Install compilation dependencies to build Python from source
sudo pacman -S --noconfirm --needed base-devel openssl zlib xz tk
curl https://pyenv.run | bash
if [ "$(basename "$SHELL")" == "fish" ]; then
    echo "[*] Adding pyenv to fish config..."
    set -Ux PYENV_ROOT "$HOME"/.pyenv
fi

cd ~

echo "[*] Creating directories..."
mkdir -p obsidian pictures/{wallpapers,screenshots} projects &> /dev/null

echo "[*] Cloning dotfiles..."
git clone $DOTFILES_URL .dotfiles
cd .dotfiles
for folder in *; do
    if [[ -e "$HOME/.config/$folder" ]]; then
        echo "[*] Creating backup of $folder"
        mv "$HOME/.config/$folder" "$HOME/.config/${folder}_bak"
    fi
done

stow ./*/
cd -

echo "Disabling root login..."
sudo passwd -l root

wget $WALLPAPER_URL -O ~/pictures/wallpapers/active.png
