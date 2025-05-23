# dotfiles

This is my personal setup, **I strongly discourage using the initialization script unless you're me**. I recommend
looking through the files and picking bits and pieces that fit your workflows.

## Setup

Make sure `git` and `curl` are installed before running the dotfiles initialization script. For example, in Ubuntu:

```sh
sudo apt install -y git curl
```

Then run the dotfiles script, which installs everything into your `$HOME` directory:

```sh
curl -sSL benelan.dev/s/dotfiles | sh
```

If the link above dies, use the [`dot`](../.dotfiles/bin/dot) script's `init` subcommand instead:

```sh
curl -sSL https://raw.githubusercontent.com/benelan/dotfiles/master/.dotfiles/bin/dot | bash -s init
```

The scripts do the same thing, but the first link is easier for me to remember and type.

The script will backup any conflicting files to `~/.dotfiles-backup`. It will set up the dotfiles as a bare git repo,
which makes syncing changes easy. You can also create separate branches for different machines. Read this
[Atlassian tutorial] for more info. A common alternative is managing dotfiles with symlinks (e.g., [GNU stow]), but in
my experience that can get messy.

## `dot` command

The `dot` script has the following custom subcommands:

- `init`: Initialize the dotfiles bare repo, as mentioned [above](#setup).

- `clone`: Clone a repo to the `$LIB` directory (see [`exports.sh`](../.dotfiles/shell/exports.sh)) instead of `$PWD`.

- `deps`: Install various dependencies, including development tools, GUI apps, shell scripts, fonts, themes, and more.
  See `dot deps -h` for usage info.

- `edit`: Open nvim/vim with environment variables set so git plugins work with the bare dotfiles repo.

All other subcommands and their arguments are passed to `git` with environment variables set to ensure `dot` always
runs on the bare repo. A typical workflow for adding a new config file to the repo is:

```sh
dot add .config/xyz/config.yml
dot commit -m "chore(xyz): add config"
dot push
```

Technically, the whole home directory is under version control. However, [`.gitignore`](../.gitignore) blacklists
everything, and then whitelists specific directories and files. This adds an extra level of security and prevents most
files from being untracked. The remaining untracked files are hidden from `dot status`, so you need to `dot add` new
files/directories before they show up.

Git's bash completion and the git aliases defined at the bottom of [`~/.config/git/config`](../.config/git/config) will
also work for `dot`.

## Operating systems

### Linux

My setup was primarily created for Ubuntu/Debian and their derivatives. However, I try to separate the Ubuntu-only code
and make sure executables exist before using them. The main issue you'll face with other linux distros is missing
dependencies, which I install with `dot deps -U` on Ubuntu. See the [apt dependency lists], although names may vary
depending on your distro's package manager.

### macOS

Mac users should [switch to the GNU version] of command line utilities. I strongly suggest switching even if you don't
copy anything from this repo, because it will align your local development environment with production. Linux uses the
GNU version of utils, and most servers, containers, and continuous integration runners use Linux.

### Windows

It's safe to assume nothing in this repo will work on Windows. However, I occasionally need Windows for my job and can
confirm this setup works in [WSL running Ubuntu].

## Configuration

Put machine-specific stuff in `~/.profile.local` and/or `~/.bashrc.local`, both of which get sourced (if they exist) by
their respective files.

The following environment variables are flags that accept a value of `1` or `0` to enabled/disable tools and other
functionality.

- `DESKTOP_MACHINE` - Install and use GUI tools that only work on desktop machines.

- `WORK_MACHINE` - Setup the environment for work (aliases functions, etc.)

- `COPILOT` - Use the GitHub Copilot plugin in Neovim.

- `CODEIUM` - Use the Codeium (free Copilot alternative) plugin in Neovim.

- `NERD_FONT` - Use developer icons in Neovim/Vim/Vifm/etc. [Wezterm ships with Nerd Font glyphs], so the icons are
  displayed by default unless explicitly disabled by setting the option to `0`. If you don't use Wezterm, make sure to
  install a [Nerd Font] (e.g. `dot deps -t font`) before enabling the icons by setting the option to `1`.

## Credits

I learned and stole a lot from the following sources. There are credits/links in specific files as well, when relevant.

- Copyright (c) 2020-2021 Bash-it `MIT` [[code](https://github.com/Bash-it/bash-it)]

- Copyright (c) LazyVim `Apache License 2.0` [[code](https://github.com/LazyVim/LazyVim)]

- Tom Ryder [[code](https://dev.sanctum.geek.nz/cgit/dotfiles.git/tree/)]

- Seth House [[code](https://github.com/whiteinge/dotfiles)]

[Atlassian tutorial]: https://www.atlassian.com/git/tutorials/dotfiles
[GNU stow]: https://www.gnu.org/software/stow/
[Nerd Font]: https://www.nerdfonts.com/
[WSL running Ubuntu]: https://ubuntu.com/desktop/wsl
[Wezterm ships with Nerd Font glyphs]: https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
[apt dependency lists]: https://github.com/benelan/dotfiles/blob/4c9a56310effe37ad5f483d9d87fcff85d82ce1c/.dotfiles/bin/dot#L753-L1012
[switch to the GNU version]: https://ryanparman.com/posts/2019/using-gnu-command-line-tools-in-macos-instead-of-freebsd-tools/
