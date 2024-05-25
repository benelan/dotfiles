# dotfiles

This is my personal setup, **I strongly discourage using the setup script unless
you're me**. I recommend looking through the files and picking bits and pieces
that fit your workflows.

## Setup

To install the dotfiles in your `$HOME` directory, run:

```sh
curl -sSL benelan.dev/s/dotfiles | sh
```

If the link above dies, use the [`dot`](../.dotfiles/bin/dot) script's `init`
subcommand instead.

```sh
curl -sSL https://raw.githubusercontent.com/benelan/dotfiles/master/.dotfiles/bin/dot | bash -s init
```

The script will backup any conflicting files to `~/.dotfiles-backup`. It
will set up the dotfiles as a bare git repo, which makes syncing changes easy.
You can also create separate branches for different machines. Read
[this tutorial](https://www.atlassian.com/git/tutorials/dotfiles) for more info.
A common alternative is managing dotfiles with symlinks (e.g.,
[GNU stow](https://www.gnu.org/software/stow/)), but in my experience that can
get messy.

## `dot` command

The `dot` script has the following custom subcommands:

- `init`: Setup the dotfiles bare repo, as mentioned [above](#setup).
- `deps`: Install various dependencies, including development tools, GUI apps,
  shell scripts, fonts, themes, and more. See `dot deps -h` for usage info.
- `edit`: Open nvim/vim with environment variables set so git plugins work with
  the bare dotfiles repo.
- `get`: Clone a repo to the `$LIB` directory instead of `$PWD`.

All other subcommands and their arguments are passed to `git`, with environment
variables set to ensure `dot` always runs on the bare repo. Untracked files are
hidden, since technically the whole home directory is under version control.
Therefore, you need to add files before they show up in status and diff. A
typical workflow for adding a new config file to the repo is:

```sh
dot add .config/xyz/config.yml
dot commit -m "chore(xyz): add config"
dot push
```

Git bash completion and the git aliases defined at the bottom of
[`~/.config/git/config`](../.config/git/config) will also work for `dot`.

## Operating systems

### Linux

My setup was primarily created for Ubuntu/Debian and their derivatives. However,
I try to separate the Ubuntu-only code and make sure executables exist before
using them. The main issue you'll face with other linux distros is missing
dependencies, which I install with `dot deps -U` on Ubuntu. See the `apt`
[dependency lists](../.dotfiles/deps), although names may vary depending on your
distro's package manager.

### macOS

Mac users should [follow these steps](https://ryanparman.com/posts/2019/using-gnu-command-line-tools-in-macos-instead-of-freebsd-tools/)
to switch to the GNU version of command line utilities. I strongly suggest
switching even if you don't copy anything from this repo, because it will align
your local development environment with production. Linux uses the GNU version
of utils, and most servers, containers, and continuous integration runners use
Linux.

### Windows

It's safe to assume nothing in this repo will work on Windows. However, I
occasionally need Windows for my job and can confirm this setup works in WSL
running Ubuntu.

## Configuration

Put machine-specific stuff in `~/.dotfiles/shell/local.sh`, which gets sourced
in [`~/.bashrc`](../.bashrc) if it exists. The following environment variables
are flags that accept a value of `1` or `0` (default) to enabled/disable tools
and other functionality.

- `USE_GUI_APPS` - Install and use tools that only work on desktop machines.
- `USE_WORK_STUFF` - Setup the environment for work (aliases functions, etc.)
- `USE_COPILOT` - Use the GitHub Copilot plugin in Neovim.
- `USE_CODEIUM` - Use the Codeium (free Copilot alternative) plugin in Neovim.
- `USE_DEVICONS` - Use developer icons in various tools. The icons are displayed
  in Neovim/Vim/Vifm/etc. by default when using Wezterm (since it
  [ships with Nerd Font glyphs](https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html)),
  but they can be disabled by setting the option to `0`. If you don't use
  Wezterm, make sure to [install a Nerd Font](https://www.nerdfonts.com/) (e.g.
  `dot deps -t font`) before setting the option to `1`.

## Credits

I learned and stole a lot from the following sources. There are credits/links in
specific files as well, when relevant.

- Copyright (c) 2020-2021 Bash-it `MIT` [[code](https://github.com/Bash-it/bash-it)]

- Copyright (c) LazyVim `Apache License 2.0` [[code](https://github.com/LazyVim/LazyVim)]

- Tom Ryder [[code](https://dev.sanctum.geek.nz/cgit/dotfiles.git/tree/)]

- Seth House [[code](https://github.com/whiteinge/dotfiles)]
