gpg_keys=()
apt_source_files=()
apt_source_texts=()
apt_packages=()
deb_installed=()
deb_sources=()

installers_path="$DOTFILES/caches/installers"

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function e_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }


function add_ppa() {
  apt_source_texts+=($1)
  IFS=':/' eval 'local parts=($1)'
  apt_source_files+=("${parts[1]}-ubuntu-${parts[2]}-$release_name")
}

#############################
# WHAT DO WE NEED TO INSTALL?
#############################

# Core
apt_packages+=(
  wget
  gpg
  git
  apt-transport-https
  build-essential
  make
  cargo
  golang
  python3
  pip
  curl
  htop
  id3tool
  imagemagick
  nmap
  postgresql
  duf
  silversearcher-ag
  telnet
  thefuck
  tree
  taskwarrior
  shellcheck
  python3
  python3-pip
  neofetch
  mount
  grep
  ripgrep
  fzf
  fasd
  findutils
  gzip
  golang
  cron
  coreutils
  handbrake-cli
  vim
)

# Fun
# apt_packages+=(
#   cmatrix
#   cowsay
#   hollywood
#   sl
# )


# https://github.com/neovim/neovim/wiki/Installing-Neovim
add_ppa ppa:neovim-ppa/stable
apt_packages+=(neovim)


# https://protonvpn.com/support/linux-vpn-tool/
deb_installed+=(/usr/bin/protonvpn-cli)
deb_sources+=(https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3_all.deb)


# only install GUI deps on servers by running script like:
# IS_SERVER_DOTFILE_INSTALL=true && install-apt-deps.bash
if [[ -z "$IS_SERVER_DOTFILE_INSTALL"]]; then

  # https://code.visualstudio.com/Download
  deb_installed+=(/usr/bin/code)
  deb_sources+=(https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64)

  # https://brave.com/linux/
  gpg_keys+=(https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg)
  apt_source_files+=(brave-browser-release)
  apt_source_texts+=("deb [signed-by=/usr/share/keyrings/brave-browser-release-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main")
  apt_packages+=(brave-browser)

  # More
  apt_packages+=(
    chromium-browser
    fonts-mplus
    gnome-tweaks
    # rofi
    vlc
    xclip
    zenmap
    handbrake
    tilda
    calibre
    transmission
  )

  # https://be5invis.github.io/Iosevka/
  # https://launchpad.net/~laurent-boulard/+archive/ubuntu/fonts
  add_ppa ppa:laurent-boulard/fonts
  apt_packages+=(fonts-iosevka)

  # https://github.com/alacritty/alacritty
  # https://launchpad.net/~aslatter/+archive/ubuntu/ppa
  add_ppa ppa aslatter/ppa
  apt_package+=(alacritty)
  
fi

function other_stuff() {
  # Install Git Extras
  # if [[ ! "$(type -P git-extras)" ]]; then
  #   e_header "Installing Git Extras"
  #   (
  #     cd $DOTFILES/vendor/git-extras &&
  #     sudo make install
  #   )
  # fi

  # Install misc bins from zip file.
  # install_from_zip ngrok 'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip'

  # Install SourceCodePro Patched Nerd Font if they aren't already there
  # https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/SourceCodePro
  mkdir -p ~./fonts
  if [[ $(find ~/.fonts -iname 'Sauce Code Pro*Nerd Font Complete.ttf' | wc -l) -lt 5 ]]; then 
    cd ~/.local/share/fonts && curl -fLo "Sauce Code Pro Medium Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Medium/complete/Sauce%20Code%20Pro%20Medium%20Nerd%20Font%20Complete.ttf
    cd ~/.local/share/fonts && curl -fLo "Sauce Code Pro Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf
    cd ~/.local/share/fonts && curl -fLo "Sauce Code Pro Bold Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Bold/complete/Sauce%20Code%20Pro%20Bold%20Nerd%20Font%20Complete.ttf
    cd ~/.local/share/fonts && curl -fLo "Sauce Code Pro Italic Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Italic/complete/Sauce%20Code%20Pro%20Italic%20Nerd%20Font%20Complete.ttf
    cd ~/.local/share/fonts && curl -fLo "Sauce Code Pro Bold Italic Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Black-Italic/complete/Sauce%20Code%20Pro%20Black%20Italic%20Nerd%20Font%20Complete.ttf
  fi

  # Install volta if necessary
  if [[ ! "$VOLTA_HOME" ]]; then
    curl https://get.volta.sh | bash -s -- --skip-setup
    export VOLTA_HOME=~/.volta
    grep --silent "$VOLTA_HOME/bin" <<< $PATH || export PATH="$VOLTA_HOME/bin:$PATH"
    volta install node
    volta install yarn
    volta install tsc
  fi


  # Install LunarVim
  # https://www.lunarvim.org/docs/installation
  bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) --install-dependencies --yes
}

####################
# ACTUALLY DO THINGS
####################

# Add GPG keys.
function __temp() { [[ ! -e /usr/share/keyrings/"$1"-archive-keyring.gpg ]]; }
gpg_key_i=($(array_filter_i gpg_keys __temp))

if (( ${#gpg_key_i[@]} > 0 )); then
  e_header "Adding GPG keys (${#gpg_key_i[@]})"
  for i in "${gpg_key_i[@]}"; do
    source_file=${apt_source_files[i]}
    gpg_key=${gpg_keys[i]}
    sudo curl -fsSLo /usr/share/keyrings/"$source_file"-archive-keyring.gpg "$gpg_key"
  done
fi


# Add APT sources.
function __temp() { [[ ! -e /etc/apt/sources.list.d/"$1".list ]]; }
source_i=($(array_filter_i apt_source_files __temp))

if (( ${#source_i[@]} > 0 )); then
  e_header "Adding APT sources (${#source_i[@]})"
  for i in "${source_i[@]}"; do
    source_file=${apt_source_files[i]}
    source_text=${apt_source_texts[i]}
    if [[ "$source_text" =~ ppa: ]]; then
      e_arrow "$source_text"
      sudo add-apt-repository -y $source_text
    else
      e_arrow "$source_file"
      sudo sh -c "echo '$source_text' > /etc/apt/sources.list.d/$source_file.list"
    fi
  done
fi

# Update/Upgrade APT.
e_header "Updating APT"
sudo apt -qq update
e_header "Upgrading APT"
sudo apt -qy upgrade


# Install APT packages.
installed_apt_packages="$(dpkg --get-selections | grep -v deinstall | awk 'BEGIN{FS="[\t:]"}{print $1}' | uniq)"
apt_packages=($(setdiff "${apt_packages[*]}" "$installed_apt_packages"))

if (( ${#apt_packages[@]} > 0 )); then
  e_header "Installing APT packages (${#apt_packages[@]})"
  for package in "${apt_packages[@]}"; do
    e_arrow "$package"
    [[ "$(type -t preinstall_$package)" == function ]] && preinstall_$package
    sudo apt -qq install "$package" && \
    [[ "$(type -t postinstall_$package)" == function ]] && postinstall_$package
  done
fi

# Install debs via dpkg
function __temp() { [[ ! -e "$1" ]]; }
deb_installed_i=($(array_filter_i deb_installed __temp))

if (( ${#deb_installed_i[@]} > 0 )); then
  mkdir -p "$installers_path"
  e_header "Installing debs (${#deb_installed_i[@]})"
  for i in "${deb_installed_i[@]}"; do
    e_arrow "${deb_installed[i]}"
    deb="${deb_sources[i]}"
    [[ "$(type -t "$deb")" == function ]] && deb="$($deb)"
    installer_file="$installers_path/$(echo "$deb" | sed 's#.*/##')"
    wget -O "$installer_file" "$deb"
    sudo dpkg -i "$installer_file"
  done
fi

# install bins from zip file
function install_from_zip() {
  local name=$1 url=$2 bins b zip tmp
  shift 2; bins=("$@"); [[ "${#bins[@]}" == 0 ]] && bins=($name)
  if [[ ! "$(which $name)" ]]; then
    mkdir -p "$installers_path"
    e_header "Installing $name"
    zip="$installers_path/$(echo "$url" | sed 's#.*/##')"
    wget -O "$zip" "$url"
    tmp=$(mktemp -d)
    unzip "$zip" -d "$tmp"
    for b in "${bins[@]}"; do
      sudo cp "$tmp/$b" "/usr/local/bin/$(basename $b)"
    done
    rm -rf $tmp
  fi
}

# Run anything else that may need to be run.
type -t other_stuff >/dev/null && other_stuff
