#!/usr/bin/env bash

# VIRTUALBOX

Start: View - Auto-Resize Guest Display
Start: Devices - Shared Clipboard - Bidirectional

If not working, try the following two things:

Power off
Settings: Display: 128 MB Video Memory, VMSVGA, 3D Acceleration
Start

#lsblk
sudo mkdir -p /mnt/cdrom
sudo mount /dev/sr0 /mnt/cdrom
#ls /mnt/cdrom
sudo sh /mnt/cdrom/VBoxLinuxAdditions.run
sudo reboot

# VARIABLES

email="your-email@example.com"
name="Your Name"

# INSTALL

sudo apt update
sudo apt upgrade


sudo apt install pipx -y && pipx ensurepath && source ~/.bashrc
pipx install oca-port

sudo apt install snapd
sudo snap install brave
sudo snap install codium --classic
sudo snap install onlyoffice-desktopeditors
#sudo snap install vivaldi && sudo ln -s /snap/bin/vivaldi.vivaldi-stable /snap/bin/vivaldi

sudo apt install wmctrl # winrun dependency for X11
# sudo apt install qtchooser
sudo apt install qt6-tools-dev-tools # winrun dependency for Wayland

sudo apt install xclip # Copy (e.g. xclip -sel clip < ~/.ssh/id_ed25519.pub)

# SSH

ssh-keygen -t ed25519 -C $email
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# GIT

git config --global user.email $email
git config --global user.name $name

# GITHUB

xclip -sel clip < ~/.ssh/id_ed25519.pub
# https://github.com/settings/keys

mkdir -p ~/src/gh && cd ~/src/gh
wget https://raw.githubusercontent.com/loym-com/tools-odoo-sh/refs/heads/main/local-dev/gitclone.py

# HN-LOCALHOST

python3 gitclone.py git@github.com:norlinhenrik/hn-localhost.git
ln -s ~/src/gh/norlinhenrik/hn-localhost/main/kubuntu/local-share-applications ~/.local/share/applications
ln -s ~/src/gh/norlinhenrik/hn-localhost/main/winrun ~/.local/bin/winrun
echo '# Created by Henrik Norlin' >> ~/.profile
echo 'rm "$HOME/.cache/winrun/windows.json"' >> ~/.profile

# HN-LOCALHOST-KWIN

mkdir -p ~/.local/share/kwin/scripts
ln -s ~/src/gh/norlinhenrik/hn-localhost/main/kubuntu/local-share-kwin-scripts-winrun ~/.local/share/kwin/scripts/winrun
kpackagetool6 --type KWin/Script -i ~/.local/share/kwin/scripts/winrun

# BRAVE

# Applications: Drag Brave profiles to the bottom panel.
# Do with each profile:
# - Set name and color
# - Install Odoo Debug
# - Install Bitwarden
# - Sync Brave (use key saved in Bitwarden)

# CODIUM

codium --install-extension cline.cline
codium --install-extension Continue.continue
