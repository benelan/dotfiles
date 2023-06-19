#!/usr/bin/env sh
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

install_abolish() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/tpope/vim-abolish/master/plugin/abolish.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/tpope/vim-abolish/master/doc/abolish.txt
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

install_eunuch() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/tpope/vim-eunuch/master/plugin/eunuch.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/tpope/vim-eunuch/master/doc/eunuch.txt
}

install_rsi() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/tpope/vim-rsi/master/plugin/rsi.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/tpope/vim-rsi/master/doc/rsi.txt
}

install_obsession() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/tpope/vim-obsession/master/plugin/obsession.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/tpope/vim-obsession/master/doc/obsession.txt
}

install_vinegar() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/tpope/vim-vinegar/master/plugin/vinegar.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/tpope/vim-vinegar/master/doc/vinegar.txt
}

install_fugitive() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/tpope/vim-fugitive/master/plugin/fugitive.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/tpope/vim-fugitive/master/doc/fugitive.txt
    $INSTALL_CMD $VIM_AUTOLOAD \
        https://raw.githubusercontent.com/tpope/vim-fugitive/master/autoload/fugitive.vim
    $INSTALL_CMD $VIM_SYNTAX \
        https://raw.githubusercontent.com/tpope/vim-fugitive/master/syntax/fugitive.vim
    $INSTALL_CMD $VIM_SYNTAX \
        https://raw.githubusercontent.com/tpope/vim-fugitive/master/syntax/fugitiveblame.vim
    $INSTALL_CMD "$VIM_DIR/ftdetect" \
        https://raw.githubusercontent.com/tpope/vim-fugitive/master/ftdetect/fugitive.vim
    $INSTALL_CMD "$VIM_DIR/ftplugin" \
        https://raw.githubusercontent.com/tpope/vim-fugitive/master/ftplugin/fugitiveblame.vim
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

install_codi() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/metakirby5/codi.vim/master/plugin/codi.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/metakirby5/codi.vim/master/doc/codi.txt
    $INSTALL_CMD $VIM_AUTOLOAD \
        https://raw.githubusercontent.com/metakirby5/codi.vim/master/autoload/codi.vim
    $INSTALL_CMD "$VIM_AUTOLOAD/codi" \
        https://raw.githubusercontent.com/metakirby5/codi.vim/master/autoload/codi/load.vim
}

install_easy_align() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/junegunn/vim-easy-align/master/plugin/easy_align.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/junegunn/vim-easy-align/master/doc/easy_align.txt
    $INSTALL_CMD $VIM_AUTOLOAD \
        https://raw.githubusercontent.com/junegunn/vim-easy-align/master/autoload/easy_align.vim
}

install_exchange() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/tommcdo/vim-exchange/master/plugin/exchange.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/tommcdo/vim-exchange/master/doc/exchange.txt
}

install_grepper() {
    $INSTALL_CMD $VIM_PLUGIN \
        https://raw.githubusercontent.com/mhinz/vim-grepper/master/plugin/grepper.vim
    $INSTALL_CMD $VIM_DOC \
        https://raw.githubusercontent.com/mhinz/vim-grepper/master/doc/grepper.txt
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

# install_abolish
install_commentary
install_eunuch
# install_fugitive
# install_obsession
install_repeat
# install_rsi
install_surround
# install_vinegar

install_closer
# install_codi
# install_easy_align
# install_exchange
# install_grepper
install_gruvbox_material
# install_rooter
# install_undotree

# generate help tags
vim +"helptags ~/.vim/doc" +"quit"

unset VIM_AUTOLOAD VIM_COLORS VIM_DIR VIM_DOC VIM_PLUGIN VIM_SYNTAX
