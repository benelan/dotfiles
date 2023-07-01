#!/usr/bin/env bash
# shellcheck disable=2015

# Install scripts specific to Ubuntu/Debian based operating systems

set -e
sudo -v

DEPS_DIR="$HOME/.dotfiles/deps"
CACHE_DIR="$HOME/.dotfiles/cache"

# Install CLI apt packages
# https://manpages.ubuntu.com/manpages/jammy/man8/apt.8
install_apt_packages() {
    if [ -f "$DEPS_DIR/apt" ]; then
        while IFS="" read -r pkg || [ -n "$pkg" ]; do
            sudo apt install "$pkg" || true
        done <"$DEPS_DIR/apt"
        unset pkg
    fi
}

# Install GUI apt packages
install_apt_gui_packages() {
    if [ -f "$DEPS_DIR/apt-gui" ]; then
        while IFS="" read -r pkg || [ -n "$pkg" ]; do
            sudo apt install "$pkg" || true
        done <"$DEPS_DIR/apt-gui"
        unset pkg
    fi
}

# Install VS Code
# https://code.visualstudio.com/docs/setup/linux
install_vscode() {
    if ! is-supported code; then
        deb="$CACHE_DIR/vscode.deb"
        curl -ssLo "$deb" \
            "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
        sudo apt install -y "$deb" || true
        unset deb
    fi
}

# Install ProtonVPN CLI
# https://protonvpn.com/support/linux-vpn-tool/#debian
install_protonvpn_cli() {
    if ! is-supported protonvpn-cli; then
        checksum="c409c819eed60985273e94e575fd5dfd8dd34baef3764fc7356b0f23e25a372c"
        deb="protonvpn-stable-release_1.0.3_all.deb"
        curl -sSLo "$CACHE_DIR/$deb" \
            "https://repo.protonvpn.com/debian/dists/stable/main/binary-all/$deb"
        echo "$checksum $CACHE_DIR/$deb" | sha256sum --check -
        sudo apt install -y "$CACHE_DIR/$deb" || true
        unset deb
    fi
}

# Install Discord
# https://discord.com/download
install_discord() {
    if ! is-supported discord; then
        deb="$CACHE_DIR/discord.deb"
        curl -sSLo "$deb" \
            https://discord.com/api/download?platform=linux\&format=deb
        sudo apt install -y "$deb"
        unset deb
    fi
}

# Install WezTerm
# https://wezfurlong.org/wezterm/install/linux.html
install_wezterm() {
    deb="wezterm-nightly.Ubuntu22.04.deb"
    curl -sSLo "$CACHE_DIR/$deb" \
        "https://github.com/wez/wezterm/releases/download/nightly/$deb"
    sudo apt install -y "$CACHE_DIR/$deb" || true
    unset deb

    # https://wezfurlong.org/wezterm/config/lua/config/term.html
    tempfile=$(mktemp) &&
        curl -o "$tempfile" \
            https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo &&
        tic -x -o ~/.terminfo "$tempfile" &&
        rm "$tempfile"
}

# Install Taskwarrior TUI
# https://github.com/kdheepak/taskwarrior-tui
install_taskwarrior_tui() {
    if ! is-supported taskwarrior-tui; then
        deb="taskwarrior-tui.deb"
        curl -sSLo "$CACHE_DIR/$deb" "https://github.com/kdheepak/taskwarrior-tui/releases/latest/download/$deb"
        sudo apt install -y "$CACHE_DIR/$deb" || true
    fi
}

# Install Docker Desktop
# https://docs.docker.com/desktop/install/ubuntu/
install_docker_desktop() {
    if ! is-supported docker-desktop; then
        deb="docker-desktop-4.16.2-amd64.deb"
        rm -r ~/.docker/desktop || true
        sudo rm /usr/local/bin/com.docker.cli || true
        sudo apt purge docker-desktop || true
        curl -sSLo "$CACHE_DIR/$deb" \
            "https://desktop.docker.com/linux/main/amd64/$deb"
        sudo apt install "$CACHE_DIR/$deb" || true
        unset deb
    fi
}

# Install Docker Engine
# https://docs.docker.com/engine/install/ubuntu/
install_docker_engine() {
    if ! is-supported docker; then
        sudo mkdir -m 0755 -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
            sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
                sudo chmod a+r /etc/apt/keyrings/docker.gpg

        echo "deb [arch=$(dpkg --print-architecture) \
      signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" |
            sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin || true
    fi
}

# Install GitHub CLI
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
install_gh_cli() {
    if ! is-supported gh; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |
            sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
            sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
            echo "deb [arch=$(dpkg --print-architecture) \
          signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
          https://cli.github.com/packages stable main" |
            sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
            sudo apt update &&
            sudo apt install -y gh || true
    fi
}

# Install Brave Browser
# https://brave.com/linux/#debian-ubuntu-mint
install_brave_browser() {
    if ! is-supported brave-browser; then
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
            https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
         https://brave-browser-apt-release.s3.brave.com/ stable main" |
            sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        sudo apt update
        sudo apt install -y brave-browser || true
    fi
}

install_gnome_gruvbox_theme() {
    if [[ "$(os-detect)" =~ "linux_pop" ]]; then
        # download gruvbox gnome theme and icons
        git -C "$CACHE_DIR" clone --depth=1 https://github.com/SylEleuth/gruvbox-plus-icon-pack.git
        git -C "$CACHE_DIR" clone --depth=1 https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git

        cursors="FlatbedCursors-0.5.2.tar.bz2"
        curl -sSLo "$cursors" "https://limitland.gitlab.io/flatbedcursors/$cursors"
        extract "$cursors"
        unset cursors

        # move icons and themes to the proper locations
        mkdir -p ~/.icons/FlatbedCursors-Orange/ ~/.icons/Gruvbox-Plus-Dark ~/.themes/Gruvbox-Dark-BL
        cp -r "$CACHE_DIR"/gruvbox-plus-icon-pack/Gruvbox-Plus-Dark/* ~/.icons/Gruvbox-Plus-Dark/
        cp -r "$CACHE_DIR"/Gruvbox-GTK-Theme/themes/Gruvbox-Dark-BL/* ~/.themes/Gruvbox-Dark-BL/
        cp -r ./FlatbedCursors-Orange/* ~/.icons/FlatbedCursors-Orange/

        # remove the repos because they are yuuge
        rm -rf "$CACHE_DIR/gruvbox-plus-icon-pack" "$CACHE_DIR/Gruvbox-GTK-Theme" ./FlatbedCursors*
    fi
}

# CLI install scripts (suitable for servers)
install_apt_packages
install_gh_cli
install_protonvpn_cli
install_taskwarrior_tui
install_docker_engine

# GUI install scripts
install_apt_gui_packages
install_gnome_gruvbox_theme
install_discord
install_vscode
install_brave_browser
install_wezterm
# install_docker_desktop

sudo apt -y update && sudo apt -y upgrade
