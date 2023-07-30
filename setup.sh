#!/bin/bash
set -e

#DOTFILES_URL=https://github.com/vbjeronimo/.dotfiles.git
DOTFILES_URL=git@github.com:vbjeronimo/.dotfiles.git
WALLPAPER_URL=https://w.wallhaven.cc/full/9m/wallhaven-9mjoy1.png
LIGHTDM_GREETER=lightdm-gtk-greeter

setup() {
    cd ~

    echo "Updating the system..."
    sudo pacman -Syu --noconfirm

    echo "Installing video drivers..."
    if lspci | grep -q "NVIDIA"; then
        sudo pacman -S --noconfirm --needed nvidia nvidia-utils nvidia-settings
    elif lspci | grep -q "AMD"; then
        sudo pacman -S --noconfirm --needed xf86-video-amdgpu
    elif lspci | grep -q "Intel"; then
        sudo pacman -S --noconfirm --needed xf86-video-intel
    fi

    echo "Installing packages..."
    sudo pacman -S --noconfirm --needed \
        lightdm $LIGHTDM_GREETER qtile dunst rofi \
        kitty firefox thunderbird discord obsidian libreoffice-fresh \
        neovim tmux fd ripgrep exa bat ufw syncthing feh starship xclip fzf xdg-user-dirs \
        playerctl \
        ttf-firacode-nerd ttf-liberation ttf-dejavu ttf-ubuntu-font-family noto-fonts-emoji \
        papirus-icon-theme \
        wget zip unzip openssh git pass npm python-pip \
        networkmanager network-manager-applet \
        stow ranger docker bpytop autorandr \
        qemu libvirt virt-manager dnsmasq

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=$LIGHTDM_GREETER/" /etc/lightdm/lightdm.conf
    sudo sed -i "s/enabled=True/enabled=False/" /etc/xdg/user-dirs.conf

    if ! systemctl is-enabled docker &> /dev/null; then
        echo "Setting up docker..."
        sudo systemctl enable docker.service
        sudo systemctl enable containerd.service
        sudo usermod -aG docker $USER
    fi

    if ! systemctl is-enabled ufw &> /dev/null; then
        echo "Setting up firewall..."
        sudo systemctl enable ufw.service
        sudo ufw default deny incoming
        sudo ufw default allow outgoing
        sudo ufw allow ssh
        sudo ufw enable
    fi

    echo "Enabling services..."
    ROOT_SERVICES=("lightdm" "NetworkManager")
    for service in ${ROOT_SERVICES[@]}; do
        if ! systemctl is-enabled $service &> /dev/null; then
            sudo systemctl enable ${service}.service
        fi
    done

    USER_SERVICES=("syncthing")
    for service in ${USER_SERVICES[@]}; do
        if ! systemctl is-enabled $service &> /dev/null; then
            systemctl --user enable ${service}.service
        fi
    done

    if ! systemctl is-enabled libvirtd &> /dev/null; then
        echo "Setting up libvirt..."
        sudo systemctl enable libvirtd.service
        echo "Adding $USER to the libvirt group..."
        sudo usermod -aG libvirt $USER
    fi

    if [[ "$(basename $SHELL)" != "fish" ]]; then
        echo "Setting default shell to fish..."
        # setting USERNAME here because USER is 'root' when running chsh with 'sudo'
        USERNAME=$USER
        sudo chsh -s /bin/fish $USERNAME
    fi

    echo "Creating directories..."
    mkdir -p bin obsidian pictures/{wallpapers,screenshots} projects &> /dev/null

    echo "Cloning dotfiles..."
    git clone $DOTFILES_URL .dotfiles
    cd .dotfiles
    for folder in *; do
        if [[ -e "~/.config/$folder" ]]; then
            echo "    Creating backup of $folder"
            mv "~/.config/$folder{,_bak}"
        fi
    done

    stow */
    cd -

    echo "Disabling root login..."
    sudo passwd -l root

    wget -O ~/pictures/wallpapers/active.png $WALLPAPER_URL
}

case "$1" in
    "")
        setup
        ;;
    *)
        echo "Unexpected argument: '$1'"
        exit 1
esac
