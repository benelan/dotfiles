#!/usr/bin/env bash
# shellcheck disable=1087

# This script installs the Ubuntu/Debian packages I use
# The dotfiles.init.bash script needs to run first

gpg_keys=()
apt_source_files=()
apt_source_texts=()
apt_packages=()
deb_installed=()
deb_sources=()

installers_path=~/.dotfiles/cache/installers

# Logging stuff.
function e_header() { echo -e "\n\033[1m" "$@" "\033[0m"; }
function e_success() { echo -e " \033[1;32m✔\033[0m" "$@"; }
function e_error() { echo -e " \033[1;31m✖\033[0m" "$@"; }
function e_arrow() { echo -e " \033[1;34m➜\033[0m" "$@"; }

release_name=$(lsb_release -c | awk '{print $2}')

function add_ppa() {
    apt_source_texts+=("$1")
    IFS=':/' eval 'local parts=($1)'
    apt_source_files+=("${parts[1]}-ubuntu-${parts[2]}-$release_name")
}

# Core packages
#----------------------------------------------------------------------

apt_packages+=(
    wget
    gnupg
    lsb-release
    git
    apt-transport-https
    ca-certificates
    openssl
    build-essential
    make
    golang
    python3
    ruby
    perl
    curl
    htop
    btop
    imagemagick
    nmap
    socat
    sqlite3
    duf
    telnet
    tree
    neofetch
    mount
    gzip
    cron
    datamash
    pandoc
    textlive-latex-recommended
    librsvg2-bin
    coreutils
    vim
    grep
    ripgrep
    fd-find
    findutils
    silversearcher-ag
    bat
    thefuck
    taskwarrior
    handbrake-cli
    codespell
    shellcheck
    shfmt
    # packages below needed to build Alacritty from source
    cargo
    cmake
    pkg-config
    libfreetype6-dev
    libfontconfig1-dev
    libxcb-xfixes0-dev
    libxkbcommon-dev
    python3
)

# Funny stuffs
# apt_packages+=(
#   cmatrix
#   cowsay
#   hollywood
#   sl
# )

if [[ ! "$(type -P nvim)" ]]; then
    # https://github.com/neovim/neovim/wiki/Installing-Neovim
    deb_installed+=(/usr/bin/nvim)
    deb_sources+=(https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb)
fi

if [[ ! "$(type -P protonvpn-cli)" ]]; then
    # https://protonvpn.com/support/linux-vpn-tool/
    deb_installed+=(/usr/bin/protonvpn-cli)
    deb_sources+=(https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3_all.deb)
fi

if [[ ! "$(type -P gh)" ]]; then
    # https://github.com/cli/cli/blob/trunk/docs/install_linux.md
    gpg_keys+=("https://cli.github.com/packages/githubcli-archive-keyring.gpg")
    apt_source_files+=(github-cli)
    apt_source_texts+=("deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/github-cli.gpg] https://cli.github.com/packages stable main")
    apt_packages+=(gh)
fi

if [[ ! "$(type -P docker)" ]]; then
    # https://docs.docker.com/engine/install/ubuntu
    # Alternatively, an install script is provided:
    # https://get.docker.com/
    gpg_keys+=("https://download.docker.com/linux/ubuntu/gpg")
    apt_source_files+=(docker)
    apt_source_texts+=("deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable")
    apt_packages+=(
        docker-ce
        docker-ce-cli
        containerd.io
        docker-compose-plugin
    )
fi

# Desktop Environment packages
#----------------------------------------------------------------------

# only install GUI deps on servers by running script like:
# IS_SERVER_DOTFILE_INSTALL=true && install-apt-deps.bash
if [[ -z "$IS_SERVER_DOTFILE_INSTALL" ]]; then

    if [[ ! "$(type -P code)" ]]; then
        # https://code.visualstudio.com/Download
        deb_installed+=(/usr/bin/code)
        deb_sources+=(https://code.visualstudio.com/sha/download?build=stable\&os=linux-deb-x64)
    fi

    if [[ ! "$(type -P discord)" ]]; then
        # https://discord.com/download
        deb_installed+=(/usr/bin/discord)
        deb_sources+=(https://discord.com/api/download?platform=linux\&format=deb)
    fi

    if [[ ! "$(type -P brave-browser)" ]]; then
        # https://brave.com/linux/
        gpg_keys+=("https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg")
        apt_source_files+=(brave-browser-release)
        apt_source_texts+=("deb [signed-by=/usr/share/keyrings/brave-browser-release.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main")
        apt_packages+=(brave-browser)
    fi

    apt_packages+=(
        chromium-browser
        gnome-tweaks
        # rofi
        vlc
        xclip
        handbrake
        tilda
        calibre
        transmission
        cmus
        peek
        kitty
    )

    # https://github.com/alacritty/alacritty
    # https://launchpad.net/~aslatter/+archive/ubuntu/ppa
    # add_ppa ppa aslatter/ppa
    # apt_package+=(alacritty)

fi

# Anything that needs to run after packages are installed
#----------------------------------------------------------------------

function post_install() {
    mkdir -p ~/.local/bin
    # Install Git Extras
    # if [[ ! "$(type -P git-extras)" ]]; then
    #   e_header "Installing Git Extras"
    #   (
    #     cd ~/.dotfiles/vendor/git-extras &&
    #     sudo make install
    #   )
    # fi

    # Install bins from zip file.
    # install_from_zip ngrok 'https://github.com/inconshreveable/ngrok/archive/refs/tags/1.7.1.zip'

    # Install Alacritty if all of the prereqs are installed
    if [[ -z "$IS_SERVER_DOTFILE_INSTALL" &&
        ! "$(type -P alacritty)" &&
        -d ~/.dotfiles/vendor/alacritty &&
        ("$(type -P python)" && "$(type -P cargo)" &&
        "$(type -P cmake)" && "$(type -P pkg-config)" &&
        "$(type -P libfreetype6-dev)" &&
        "$(type -P libxcb-xfixes0-dev)" &&
        "$(type -P libxkbcommon)") ]]; then

        e_header "Installing Alacritty"
        cd ~/.dotfiles/vendor/alacritty || return
        cargo build --release
        # Add Terminfo if necessary
        if [[ ! "$(infocmp alacritty)" ]]; then sudo tic -xe alacritty,alacritty-direct extra/alacritty.info; fi
        # Add Desktop Entry
        sudo cp target/release/alacritty ~/.local/bin
        sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
        sudo desktop-file-install extra/linux/Alacritty.desktop
        sudo update-desktop-database
    fi

    # link batcat to bat due to package name conflict
    [[ ! "$(type -P bat)" ]] && ln -s "$(type -P batcat)" ~/.local/bin/bat
    [[ ! "$(type -P fd)" ]] && ln -s "$(type -P fdfind)" ~/.local/bin/fd

    # clean up
    sudo apt autoclean
}

# Crazy bash array utils
#----------------------------------------------------------------------

function array_filter() { __array_filter 1 "$@"; }
function array_filter_i() { __array_filter 0 "$@"; }
function __array_filter() {
    local __i__ __val__ __mode__ __arr__
    __mode__=$1
    shift
    __arr__=$1
    shift
    for __i__ in $(eval echo "\${!$__arr__[@]}"); do
        __val__="$(eval echo "\${$__arr__[__i__]}")"
        if [[ "$1" ]]; then
            # shellcheck disable=2086
            "$@" "$__val__" $__i__ >/dev/null
        else
            [[ "$__val__" ]]
        fi
        # shellcheck disable=2181
        if [[ "$?" == 0 ]]; then
            if [[ $__mode__ == 1 ]]; then
                eval echo "\"\${$__arr__[__i__]}\""
            else
                # shellcheck disable=2086
                echo $__i__
            fi
        fi
    done
}

function setdiff() {
    local debug skip a b
    if [[ "$1" == 1 ]]; then
        debug=1
        shift
    fi
    if [[ "$1" ]]; then
        local setdiff_new setdiff_cur setdiff_out
        # shellcheck disable=2206
        setdiff_new=($1)
        # shellcheck disable=2206
        setdiff_cur=($2)
    fi
    setdiff_out=()
    for a in "${setdiff_new[@]}"; do
        skip=
        for b in "${setdiff_cur[@]}"; do
            [[ "$a" == "$b" ]] && skip=1 && break
        done
        [[ "$skip" ]] || setdiff_out=("${setdiff_out[@]}" "$a")
    done
    [[ "$debug" ]] && for a in setdiff_new setdiff_cur setdiff_out; do
        echo "$a ($(eval echo "\${#$a[*]}")) $(eval echo "\${$a[*]}")" 1>&2
    done
    [[ "$1" ]] && echo "${setdiff_out[@]}"
}

# Do the installs
#----------------------------------------------------------------------

# Add GPG keys.
function __temp() { [[ ! -e /usr/share/keyrings/"$1".gpg ]]; }
# shellcheck disable=2207
gpg_key_i=($(array_filter_i gpg_keys __temp))

if ((${#gpg_key_i[@]} > 0)); then
    e_header "Adding GPG keys (${#gpg_key_i[@]})"
    for i in "${gpg_key_i[@]}"; do
        source_file=${apt_source_files[i]}
        gpg_key=${gpg_keys[i]}
        sudo curl -fsSLo /usr/share/keyrings/"$source_file".gpg "$gpg_key"
    done
fi

# Add APT sources.
function __temp() { [[ ! -e /etc/apt/sources.list.d/"$1".list ]]; }
# shellcheck disable=2207
source_i=($(array_filter_i apt_source_files __temp))

if ((${#source_i[@]} > 0)); then
    e_header "Adding APT sources (${#source_i[@]})"
    for i in "${source_i[@]}"; do
        source_file=${apt_source_files[i]}
        source_text=${apt_source_texts[i]}
        if [[ "$source_text" =~ ppa: ]]; then
            e_arrow "$source_text"
            sudo add-apt-repository -y "$source_text"
        else
            e_arrow "$source_file"
            sudo sh -c "echo '$source_text' > /etc/apt/sources.list.d/$source_file.list"
        fi
    done
fi

# Update/Upgrade APT.
e_header "Updating APT"
sudo apt -qy update
e_header "Upgrading APT"
sudo apt -qy upgrade

# Install APT packages
installed_apt_packages="$(dpkg --get-selections | grep -v deinstall | awk 'BEGIN{FS="[\t:]"}{print $1}' | uniq)"
# shellcheck disable=2207
apt_packages=($(setdiff "${apt_packages[*]}" "$installed_apt_packages"))

if ((${#apt_packages[@]} > 0)); then
    e_header "Installing APT packages (${#apt_packages[@]})"
    for package in "${apt_packages[@]}"; do
        e_arrow "$package"
        [[ "$(type -t preinstall_"$package")" == function ]] && preinstall_"$package"
        sudo apt -qy install "$package" &&
            [[ "$(type -t postinstall_"$package")" == function ]] && postinstall_"$package"
    done
fi

# Install debs
function __temp() { [[ ! -e "$1" ]]; }
# shellcheck disable=2207
deb_installed_i=($(array_filter_i deb_installed __temp))

if ((${#deb_installed_i[@]} > 0)); then
    mkdir -p "$installers_path"
    e_header "Installing debs (${#deb_installed_i[@]})"
    for i in "${deb_installed_i[@]}"; do
        e_arrow "${deb_installed[i]}"
        deb="${deb_sources[i]}"
        [[ "$(type -t "$deb")" == function ]] && deb="$($deb)"
        installer_file="$installers_path/$(basename "${deb_installed[i]}" | sed 's#.*/##').deb"
        wget -O "$installer_file" "$deb"
        sudo apt install "$installer_file"
    done
fi

# install bins from zip file
function install_from_zip() {
    local name=$1 url=$2 bins b zip tmp
    shift 2
    bins=("$@")
    # shellcheck disable=2206
    [[ "${#bins[@]}" == 0 ]] && bins=($name)
    if [[ ! "$(which "$name")" ]]; then
        mkdir -p "$installers_path"
        e_header "Installing $name"
        # shellcheck disable=2001
        zip="$installers_path/$(echo "$url" | sed 's#.*/##')"
        wget -O "$zip" "$url"
        tmp=$(mktemp -d)
        unzip "$zip" -d "$tmp"
        for b in "${bins[@]}"; do
            sudo cp "$tmp/$b" "/usr/local/bin/$(basename "$b")"
        done
        rm -rf "$tmp"
    fi
}

# install stuff that relies on other deps and cleanup
type -t post_install >/dev/null && post_install
