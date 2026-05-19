#!/usr/bin/env bash

# VARIABLES

email="your-email@example.com"

# INSTALL

sudo apt update
sudo apt upgrade

sudo apt install pipx && pipx ensurepath && source ~/.bashrc
pipx install oca-port
pipx install oca-port-pr

sudo apt install snapd
sudo snap install brave
sudo snap install vivaldi

sudo apt install xclip # Copy (e.g. xclip -sel clip < ~/.ssh/id_ed25519.pub)

# SSH

ssh-keygen -t ed25519 -C $email
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# GITHUB

xclip -sel clip < ~/.ssh/id_ed25519.pub
# https://github.com/settings/keys

mkdir -p ~/src/gh && cd ~/src/gh
wget https://raw.githubusercontent.com/loym-com/tools-odoo-sh/refs/heads/main/local-dev/gitclone.py

# HN-LOCALHOST

python3 gitclone.py git@github.com:norlinhenrik/hn-localhost.git
ln -s ~/src/gh/norlinhenrik/hn-localhost/main/kubuntu/local-share-applications ~/.local/share/applications
ln -s ~/src/gh/norlinhenrik/hn-localhost/main/winrun ~/.local/bin/winrun
