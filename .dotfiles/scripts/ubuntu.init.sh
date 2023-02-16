#!/usr/bin/env bash
set -e

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

# Install VS Code
# https://code.visualstudio.com/docs/setup/linux
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

# Install Discord
# https://discord.com/download
function install_discord() {
    curl -sSLo ~/.dotfiles/cache/discord.deb https://discord.com/api/download?platform=linux\&format=deb
    sudo apt install ~/.dotfiles/cache/discord.deb
    sudo apt-get update
}

# Install Docker Desktop
# https://docs.docker.com/desktop/install/ubuntu/
function install_docker_desktop() {
    filename="docker-desktop-4.16.2-amd64.deb"
    # rm -r ~/.docker/desktop
    # sudo rm /usr/local/bin/com.docker.cli
    # sudo apt remove docker-desktop
    # sudo apt purge docker-desktop
    curl -sSLo ~/.dotfiles/cache/$filename https://desktop.docker.com/linux/main/amd64/$filename
    sudo apt install ~/.dotfiles/cache/$filename
    sudo apt-get update
}

# Install Docker Engine
# https://docs.docker.com/engine/install/ubuntu/
function install_docker_engine() {
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpgecho \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

# Install GitHub CLI
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
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

# Install WezTerm
# https://wezfurlong.org/wezterm/install/linux.html
function install_wezterm() {
    curl -sSLo ~/.dotfiles/cache/wezterm-nightly.deb https://github.com/wez/wezterm/releases/download/nightly/wezterm-nightly.Ubuntu22.04.deb
    sudo apt install -y ~/.dotfiles/cache/wezterm-nightly.deb
    # https://wezfurlong.org/wezterm/config/lua/config/term.html
    tempfile=$(mktemp) &&
        curl -o "$tempfile" https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo &&
        tic -x -o ~/.terminfo "$tempfile" &&
        rm "$tempfile"

}

# CLI install scripts (suitable for servers)
install_apt_packages
install_gh_cli
install_protonvpn_cli
# install_docker_engine

# GUI install scripts
install_apt_gui_packages
install_discord
install_vscode
install_brave_browser
install_wezterm
# install_docker_desktop
