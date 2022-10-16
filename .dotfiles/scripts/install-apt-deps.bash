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

# Fun
apt_packages+=(
  cmatrix
  cowsay
  hollywood
  sl
)
# Misc.
apt_packages+=(
  wget
  gpg
  apt-transport-https
  build-essential
  make
  curl
  git-core
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
  git
  fzf
  fasd
  findutils
  gzip
  golang
  cron
  coreutils
)

apt_packages+=(vim vim-gnome vim-common vim-tiny)

# https://github.com/neovim/neovim/wiki/Installing-Neovim
add_ppa ppa:neovim-ppa/stable
apt_packages+=(neovim)

# https://launchpad.net/~stebbins/+archive/ubuntu/handbrake-releases
add_ppa ppa:stebbins/handbrake-releases
apt_packages+=(handbrake-cli)

# https://github.com/rvm/ubuntu_rvm
# add_ppa ppa:rael-gc/rvm
# apt_packages+=(rvm)

# https://github.com/rbenv/ruby-build/wiki
# apt_packages+=(
#   autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev
#   libncurses5-dev libffi-dev libgdbm3 libgdbm-dev zlib1g-dev
# )

# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-16-04
# add_ppa ppa:ansible/ansible
# apt_packages+=(ansible)

# https://launchpad.net/~hnakamur/+archive/ubuntu/tmux
# add_ppa ppa:hnakamur/tmux

# https://github.com/greymd/tmux-xpanes
# add_ppa ppa:greymd/tmux-xpanes
# apt_packages+=(tmux-xpanes)


  # https://protonvpn.com/support/linux-vpn-tool/
  deb_installed+=(/usr/bin/protonvpn-cli)
  deb_sources+=(https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.3_all.deb)

if [[ -z "$IS_SERVER_INSTALL"]]; then


  # https://code.visualstudio.com/Download
  deb_installed+=(/usr/bin/code)
  deb_sources+=(https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64)


  # https://brave.com/linux/
  gpg_keys+=(https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg)
  apt_source_files+=(brave-browser-release)
  apt_source_texts+=("deb [signed-by=/usr/share/keyrings/brave-browser-release-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main")
  apt_packages+=(brave-browser)

  # Misc
  apt_packages+=(adb fastboot)
  apt_packages+=(
    chromium-browser
    fonts-mplus
    gnome-tweak-tool
    # rofi
    vlc
    xclip
    zenmap
    handbrake-gtk
    tilda
    alacritty
    calibre
  )

  # https://be5invis.github.io/Iosevka/
  # https://launchpad.net/~laurent-boulard/+archive/ubuntu/fonts
  add_ppa ppa:laurent-boulard/fonts
  apt_packages+=(fonts-iosevka)
  
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
