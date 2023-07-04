#!/bin/bash
set -e

DRIVE=/dev/nvme0n1
TIMEZONE=UTC
HOSTNAME=machine

USERNAME=arch
USER_PASSWORD=password
ROOT_PASSWORD=password

DOTFILES_URL=https://github.com/vbjeronimo/.dotfiles.git
WALLPAPER_URL=https://w.wallhaven.cc/full/9m/wallhaven-9mjoy1.png
LIGHTDM_GREETER=lightdm-gtk-greeter

echof() {
    echo -e "\n$(tput bold)$(tput setaf 7)--> [$(tput setaf 3)*$(tput setaf 7)] $1$(tput sgr0)"
}

install_arch() {
    parted -s $DRIVE \
        mklabel gpt \
        mkpart ESP fat32 1MiB 501MiB \
        mkpart root ext4 501MiB 30.5GiB \
        mkpart swap linux-swap 30.5GiB 46.5GiB \
        mkpart home ext4 46.5GiB 100% \
        set 1 esp on

    mkfs.fat -F 32 ${DRIVE}p1
    mkfs.ext4 ${DRIVE}p2
    mkswap ${DRIVE}p3
    mkfs.ext4 ${DRIVE}p4

    mount ${DRIVE}p2 /mnt
    mount --mkdir ${DRIVE}p1 /mnt/boot
    mount --mkdir ${DRIVE}p4 /mnt/home
    swapon ${DRIVE}p3

    echof "Installing base system..."
    pacstrap -K /mnt base linux linux-firmware base-devel man-{db,pages} texinfo

    echof "Generating fstab..."
    genfstab -U /mnt >> /mnt/etc/fstab

    echof "Copying script to new system..."
    cp $0 /mnt/setup.sh

    echof "Entering new system..."
    arch-chroot /mnt ./setup.sh initial_setup

    if [ -f /mnt/setup.sh ]; then
        echof "ERROR: Something went wrong in arch-chroot. Exiting..."
        exit 1
    else
        echof "Unmounting partitions..."
        umount -R /mnt
        swapoff -a
        echof "Done! You can now reboot into your new system."
    fi
}

initial_setup() {
    echof "Setting timezone..."
    ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    hwclock --systohc

    echof "Setting locale..."
    sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf

    echof "Setting hostname..."
    echo $HOSTNAME > /etc/hostname

    echof "Setting root password..."
    echo "root:$ROOT_PASSWORD" | chpasswd

    echof "Installing microcode..."
    if [[ $(lscpu | grep -o GenuineIntel) == "GenuineIntel" ]]; then
        MICROCODE=intel-ucode
    elif [[ $(lscpu | grep -o AuthenticAMD) == "AuthenticAMD" ]]; then
        MICROCODE=amd-ucode
    fi
    pacman -S --noconfirm $MICROCODE

    echof "Setting up bootloader..."
    bootctl install
    cat <<EOF > /boot/loader/entries/arch.conf
title Arch linux
linux /vmlinuz-linux
initrd /${MICROCODE}.img
initrd /initramfs-linux.img
options root=${DRIVE}p2 rw
EOF

    cat <<EOF > /boot/loader/entries/arch-fallback.conf
title Arch linux (fallback)
linux /vmlinuz-linux
initrd /${MICROCODE}.img
initrd /initramfs-linux-fallback.img
options root=${DRIVE}p2 rw
EOF

    cat <<EOF > /boot/loader/loader.conf
default arch
timeout 0
editor 0
EOF

    echof "Creating user..."
    useradd -m -G wheel $USERNAME
    echo "$USERNAME:$USER_PASSWORD" | chpasswd

    sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers

    full_setup

    rm /setup.sh
}

full_setup() {
    cd /home/$USERNAME

    echof "Setting up pacman..."
    sed -i "s/#Color/Color/" /etc/pacman.conf
    sed -i "s/#ParallelDownloads = 5/ParallelDownloads = 5/" /etc/pacman.conf
    sed -i "s/#VerbosePkgLists/VerbosePkgLists/" /etc/pacman.conf
    sed -i "s/#TotalDownload/TotalDownload/" /etc/pacman.conf

    echof "Updating the system..."
    pacman -Syu --noconfirm

    echof "Installing video drivers..."
    pacman -S --noconfirm --needed xorg-server xorg-xrandr

    if lspci | grep -q "NVIDIA"; then
        pacman -S --noconfirm --needed nvidia nvidia-utils nvidia-settings
    elif lspci | grep -q "AMD"; then
        pacman -S --noconfirm --needed xf86-video-amdgpu
    elif lspci | grep -q "Intel"; then
        pacman -S --noconfirm --needed xf86-video-intel
    fi

    echof "Installing packages..."
    pacman -S --noconfirm --needed \
        lightdm $LIGHTDM_GREETER qtile dunst dmenu \
        kitty firefox thunderbird discord obsidian libreoffice-fresh \
        neovim tmux fd ripgrep exa bat ufw syncthing feh zsh starship xclip fzf xdg-user-dirs \
        playerctl \
        ttf-firacode-nerd ttf-liberation ttf-dejavu ttf-ubuntu-font-family \
        wget zip unzip openssh git pass \
        networkmanager network-manager-applet \
        stow ranger docker bpytop \
        qemu libvirt virt-manager dnsmasq

    sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=$LIGHTDM_GREETER/" /etc/lightdm/lightdm.conf

    if ! systemctl is-enabled docker &> /dev/null; then
        echof "Setting up docker..."
        systemctl enable docker.service
        systemctl enable containerd.service
        usermod -aG docker $USER
    fi

    if ! systemctl is-enabled ufw &> /dev/null; then
        echof "Setting up firewall..."
        systemctl enable ufw.service
        ufw default deny incoming
        ufw default allow outgoing
        ufw allow ssh
        # TODO: find a way to enable ufw from within a chroot
        #ufw enable
    fi

    echof "Enabling services..."
    ROOT_SERVICES=("lightdm" "NetworkManager")
    for service in ${ROOT_SERVICES[@]}; do
        if ! systemctl is-enabled $service &> /dev/null; then
            systemctl enable ${service}.service
        fi
    done

    USER_SERVICES=("syncthing")
    for service in ${USER_SERVICES[@]}; do
        if ! systemctl is-enabled $service &> /dev/null; then
            sudo -u $USERNAME systemctl --user enable ${service}.service
        fi
    done

    if ! systemctl is-enabled libvirtd &> /dev/null; then
        echof "Setting up libvirt..."
        systemctl enable libvirtd.service
        echof "Adding $USER to the libvirt group..."
        usermod -aG libvirt $USER
    fi

    if [[ "$(basename $SHELL)" != "zsh" ]]; then
        echof "Setting default shell to zsh..."
        chsh -s /bin/zsh $USER
    fi

    echof "Creating directories..."
    sudo -u $USERNAME mkdir -p bin obsidian pictures/{wallpapers,screenshots} projects &> /dev/null

    echof "Cloning dotfiles..."
    sudo -u $USERNAME git clone $DOTFILES_URL .dotfiles
    cd .dotfiles
    for folder in *; do
        if [[ -e "$HOME/.config/$folder" ]]; then
        echo "    Creating backup of $folder"
        mv "$HOME/.config/$folder{,_bak}"
        fi
    done

    stow */
    cd -

    echof "Disabling root login..."
    passwd -l root

    wget -O /home/$USERNAME/pictures/wallpapers/active.png $WALLPAPER_URL
}

case "$1" in
    "")
        install_arch
        ;;
    initial_setup)
        initial_setup
        ;;
    *)
        echo "Usage: $0 {full}"
        exit 1
esac
