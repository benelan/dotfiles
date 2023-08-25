#!/usr/bin/env bash
# shellcheck disable=2015

# Install scripts specific to Ubuntu/Debian based operating systems

set -e
sudo -v

DEPS_DIR="$DOTFILES/deps"
CACHE_DIR="$DOTFILES/cache"
mkdir -p "$DEPS_DIR" "$CACHE_DIR"

if [ "$USE_GUI_APPS" = "1" ]; then
    FONTS_DIR="$XDG_DATA_HOME/fonts"
    WALLPAPER_DIR="$HOME/Pictures/Wallpaper"
    mkdir -p "$FONTS_DIR" "$WALLPAPER_DIR"
fi

# Install CLI apt packages
# https://manpages.ubuntu.com/manpages/jammy/man8/apt.8
install_apt_packages() {
    ! [ -f "$DEPS_DIR/apt" ] && return
    while IFS="" read -r pkg || [ -n "$pkg" ]; do
        sudo apt install -y "$pkg" || true
    done <"$DEPS_DIR/apt"
    unset pkg
}

# Install GUI apt packages
install_apt_gui_packages() {
    ! [ -f "$DEPS_DIR/apt-gui" ] && return
    while IFS="" read -r pkg || [ -n "$pkg" ]; do
        sudo apt install -y "$pkg" || true
    done <"$DEPS_DIR/apt-gui"
    unset pkg
}

# Install VS Code
# https://code.visualstudio.com/docs/setup/linux
install_vscode() {
    is-supported code && return
    deb="$CACHE_DIR/vscode.deb"
    curl -ssLo "$deb" \
        "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    sudo apt install -y "$deb" || true
    unset deb
}

# Install ProtonVPN CLI
# https://protonvpn.com/support/linux-vpn-tool/#debian
install_protonvpn_cli() {
    is-supported protonvpn-cli && return
    checksum="c409c819eed60985273e94e575fd5dfd8dd34baef3764fc7356b0f23e25a372c"
    deb="protonvpn-stable-release_1.0.3_all.deb"
    curl -sSLo "$CACHE_DIR/$deb" \
        "https://repo.protonvpn.com/debian/dists/stable/main/binary-all/$deb"
    echo "$checksum $CACHE_DIR/$deb" | sha256sum --check -
    sudo apt install -y "$CACHE_DIR/$deb" || true
    unset deb
}

# Install Discord
# https://discord.com/download
install_discord() {
    is-supported discord && return
    deb="$CACHE_DIR/discord.deb"
    curl -sSLo "$deb" \
        https://discord.com/api/download?platform=linux\&format=deb
    sudo apt install -y "$deb"
    unset deb
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
    is-supported taskwarrior-tui && return
    deb="taskwarrior-tui.deb"
    curl -sSLo "$CACHE_DIR/$deb" \
        "https://github.com/kdheepak/taskwarrior-tui/releases/latest/download/$deb"
    sudo apt install -y "$CACHE_DIR/$deb" || true
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
    is-supported docker && return
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
        sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
}

# Install latest stable git version
# https://git-scm.com/download/linux
install_latest_git() {
    grep -q "git-core/ppa" \
        /etc/apt/sources.list /etc/apt/sources.list.d/* ||
        sudo add-apt-repository -y ppa:git-core/ppa
    sudo apt install -y git
}

# Install GitHub CLI
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
install_gh_cli() {
    is-supported gh && return
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |
        sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
        echo "deb [arch=$(dpkg --print-architecture) \
          signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
          https://cli.github.com/packages stable main" |
        sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt install -y gh
}

# Install Glow CLI (Markdown rendering)
# https://github.com/charmbracelet/glow
install_glow() {
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key |
        sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" |
        sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update && sudo apt install glow
}

# Install Brave Browser
# https://brave.com/linux/#debian-ubuntu-mint
install_brave_browser() {
    is-supported brave-browser && return
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
         https://brave-browser-apt-release.s3.brave.com/ stable main" |
        sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt install -y brave-browser
}

# Install The four common font weights
# https://github.com/ryanoasis/nerd-fonts
install_font() {
    # Iosevka
    curl -sSLo "$FONTS_DIR/IosevkaNerdFont-Bold.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Bold/IosevkaNerdFont-Bold.ttf
    curl -sSLo "$FONTS_DIR/IosevkaNerdFont-BoldItalic.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Bold-Italic/IosevkaNerdFont-BoldItalic.ttf
    curl -sSLo "$FONTS_DIR/IosevkaNerdFont-Regular.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Regular/IosevkaNerdFont-Regular.ttf
    curl -sSLo "$FONTS_DIR/IosevkaNerdFont-Italic.ttf" \
        https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Iosevka/Italic/IosevkaNerdFont-Italic.ttf

    # reload the font cache
    fc-cache -rf
}

install_gruvbox_wallpaper() {
    curl -sSLo "$WALLPAPER_DIR/gruvbox_coffee.png" https://i.imgur.com/XCaXGFB.png >/dev/null 2>&1 || true
    is-supported feh &&
        feh --bg-center "$WALLPAPER_DIR/gruvbox_coffee.png" --image-bg "#3c3836"
}

install_gnome_gruvbox_theme() {
    case "$XDG_CURRENT_DESKTOP" in
        *gnome* | *GNOME*)
            # download gruvbox gnome theme and icons
            git -C "$CACHE_DIR" clone --depth=1 https://github.com/SylEleuth/gruvbox-plus-icon-pack.git
            git -C "$CACHE_DIR" clone --depth=1 https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git

            cursors="FlatbedCursors-0.5.2.tar.bz2"
            curl -sSLo "$cursors" "https://limitland.gitlab.io/flatbedcursors/$cursors"
            extract "$cursors"
            unset cursors

            # move icons and themes to the proper locations
            mkdir -p ~/.icons/FlatbedCursors-Orange/ ~/.icons ~/.themes
            cp -r "$CACHE_DIR"/gruvbox-plus-icon-pack/Gruvbox-Plus-Dark ~/.icons
            cp -r "$CACHE_DIR"/Gruvbox-GTK-Theme/themes/Gruvbox-Dark-BL ~/.themes
            cp -r ./FlatbedCursors-Orange/* ~/.icons/FlatbedCursors-Orange/

            # remove the repos because they are yuuge
            rm -rf "$CACHE_DIR/gruvbox-plus-icon-pack" "$CACHE_DIR/Gruvbox-GTK-Theme" ./FlatbedCursors*
            ;;
    esac
}

### CLI install scripts (suitable for servers)
install_apt_packages
install_latest_git
install_gh_cli
install_protonvpn_cli
install_taskwarrior_tui
install_docker_engine

### GUI install scripts
if [ "$USE_GUI_APPS" = "1" ]; then
    install_apt_gui_packages
    install_discord
    install_vscode
    install_brave_browser
    install_wezterm
    # install_docker_desktop

    # install_gnome_gruvbox_theme
    # install_gruvbox_wallpaper
    # install_font
fi

sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y
