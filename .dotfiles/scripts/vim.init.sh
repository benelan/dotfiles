#!/usr/bin/env bash
# shellcheck disable=2086
set -e

VIM_DIR="$HOME/.vim"
VIM_AUTOLOAD="$VIM_DIR/autoload"
VIM_COLORS="$VIM_DIR/colors"
VIM_DOC="$VIM_DIR/doc"
VIM_PLUGIN="$VIM_DIR/plugin"
VIM_SYNTAX="$VIM_DIR/syntax"

is-supported wget &&
    INSTALL_CMD='wget --no-cache --https-only --quiet --output-file /dev/null --directory-prefix' ||
    {
        is-supported curl &&
            INSTALL_CMD='curl --silent --show-error --location --create-dirs --remote-name --output-dir'
    } ||
    {
        echo "Error: install wget or curl" && exit 1
    }

install_repeat() {
    $INSTALL_CMD $VIM_AUTOLOAD \
        https://raw.githubusercontent.com/tpope/vim-repeat/master/autoload/repeat.vim
}

install_surround() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/tpope/vim-surround/master/plugin/surround.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/tpope/vim-surround/master/doc/surround.txt
}

install_commentary() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/tpope/vim-commentary/master/plugin/commentary.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/tpope/vim-commentary/master/doc/commentary.txt
}

install_rooter() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/airblade/vim-rooter/master/plugin/rooter.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/airblade/vim-rooter/master/doc/rooter.txt
}

install_closer() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/rstacruz/vim-closer/master/plugin/closer.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/rstacruz/vim-closer/master/doc/closer.txt
    $INSTALL_CMD $VIM_AUTOLOAD \
        https://raw.githubusercontent.com/rstacruz/vim-closer/master/autoload/closer.vim
}

install_easy_align() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/junegunn/vim-easy-align/master/plugin/easy_align.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/junegunn/vim-easy-align/master/doc/easy_align.txt
    $INSTALL_CMD $VIM_AUTOLOAD \
        https://raw.githubusercontent.com/junegunn/vim-easy-align/master/autoload/easy_align.vim
}

install_gruvbox_material() {
    $INSTALL_CMD $VIM_COLORS \
        https://raw.githubusercontent.com/sainnhe/gruvbox-material/master/colors/gruvbox-material.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/sainnhe/gruvbox-material/master/doc/gruvbox-material.txt
    $INSTALL_CMD $VIM_AUTOLOAD \
        https://raw.githubusercontent.com/sainnhe/gruvbox-material/master/autoload/gruvbox_material.vim
}

install_undotree() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/mbbill/undotree/master/plugin/undotree.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/mbbill/undotree/master/doc/undotree.txt
    $INSTALL_CMD $VIM_AUTOLOAD \
        https://raw.githubusercontent.com/mbbill/undotree/master/autoload/undotree.vim
    $INSTALL_CMD $VIM_SYNTAX \
        https://raw.githubusercontent.com/mbbill/undotree/master/syntax/undotree.vim
}

install_closer
install_commentary
install_easy_align
install_gruvbox_material
install_repeat
install_rooter
install_surround
install_undotree

unset VIM_AUTOLOAD VIM_COLORS VIM_DIR VIM_DOC VIM_PLUGIN VIM_SYNTAX
