#!/usr/bin/env bash

# Install scripts specific to Ubuntu/Debian operating systems

# Install packages for Ubuntu/Debian
# https://manpages.ubuntu.com/manpages/jammy/man8/apt.8
function install_apt_packages() {
    # shellcheck disable=2046
    sudo apt install $(cat "$HOME/.dotfiles/deps/apt")
}
function install_apt_gui_packages() {
    # shellcheck disable=2046
    sudo apt install $(cat "$HOME/.dotfiles/deps/apt-gui")
}

function install_vscode() {
    curl -ssLo ~/.dotfiles/cache/vscode.deb \
        "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    sudo apt install ~/.dotfiles/cache/vscode.deb
}

# Install ProtonVPN CLI
# https://protonvpn.com/support/linux-vpn-tool/#debian
function install_protonvpn_cli() {
    curl -sSLo ~/.dotfiles/cache/protonvpn_1.0.3.deb \
        https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3_all.deb
    sudo apt install protonvpn_1.03.deb
    sudo apt update
    sudo apt install protonvpn-cli
}

function install_discord() {
    curl -sSLo ~/.dotfiles/cache/discord.deb https://discord.com/api/download?platform=linux\&format=deb
    sudo apt install ~/.dotfiles/cache/discord.deb
    sudo apt-get update
}

function install_docker() {
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpgecho \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

function install_gh_cli() {
    type -p curl >/dev/null || sudo apt install curl -y
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |
        sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" |
        sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
        sudo apt update &&
        sudo apt install gh -y
}

# Install Brave Browser
# https://brave.com/linux/#debian-ubuntu-mint
function install_brave_browser() {
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" |
        sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt install brave-browser
}

# CLI install scripts (suitable for servers)
install_apt_packages
install_docker
install_gh_cli
install_protonvpn_cli

# GUI install scripts
install_apt_gui_packages
install_discord
install_vscode
install_brave_browser
