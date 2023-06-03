#!/bin/bash
set -e

WALLPAPER_URL=https://w.wallhaven.cc/full/9m/wallhaven-9mjoy1.png
LIGHTDM_GREETER=lightdm-gtk-greeter

echof() {
    echo -e "\n$(tput bold)$(tput setaf 7)--> [$(tput setaf 3)*$(tput setaf 7)] $1$(tput sgr0)"
}

full_setup() {
    cd ~

    echof "Updating the system..."; sleep 1
    sudo pacman -Syu --noconfirm

    echof "Installing packages..."; sleep 1
    sudo pacman -S --noconfirm --needed \
        lightdm $LIGHTDM_GREETER qtile dunst \
        kitty firefox thunderbird discord obsidian libreoffice-fresh \
        neovim tmux fd ripgrep exa bat ufw syncthing feh zsh starship xclip fzf xdg-user-dirs \
        playerctl \
        ttf-firacode-nerd ttf-liberation ttf-dejavu ttf-ubuntu-font-family \
        wget zip unzip openssh \
        networkmanager network-manager-applet \
        stow ranger docker bpytop \
        qemu libvirt virt-manager dnsmasq

    sudo sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=$LIGHTDM_GREETER/" /etc/lightdm/lightdm.conf

    if ! systemctl is-enabled docker &> /dev/null; then
        echof "Setting up docker..."; sleep 1
        sudo systemctl enable docker.service
        sudo systemctl enable containerd.service
        sudo usermod -aG docker $USER
    fi

    if ! systemctl is-enabled ufw &> /dev/null; then
        echof "Setting up firewall..."; sleep 1
        sudo systemctl enable ufw.service
        sudo ufw default deny incoming
        sudo ufw default allow outgoing
        sudo ufw allow ssh
        sudo ufw enable
    fi

    echof "Enabling services..."; sleep 1
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
        echof "Setting up libvirt..."; sleep 1
        sudo systemctl enable libvirtd.service
        echof "Adding $USER to the libvirt group..."; sleep 1
        sudo usermod -aG libvirt $USER
    fi

    if [[ "$(basename $SHELL)" == "zsh" ]]; then
        echof "Setting default shell to zsh..."; sleep 1
        sudo chsh -s /bin/zsh $USER
    fi

    echof "Creating directories..."; sleep 1
    mkdir -p bin obsidian pictures/{wallpapers,screenshots} projects &> /dev/null

    echof "Cloning dotfiles..."; sleep 1
    cd dotfiles
    for folder in *; do
        if [[ -e "$HOME/.config/$folder" ]]; then
        echo "    Creating backup of $folder"
        mv "$HOME/.config/$folder{,_bak}"
        fi
    done

    stow */
    cd ~

    wget -O ~/pictures/wallpapers/active.png $WALLPAPER_URL
}

# if no arguments are passed, run the full setup
# otherwise, run the function passed as argument
if [ $# -eq 0 ]; then
    full_setup
else
    $1
fi
