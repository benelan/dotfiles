# dotfiles

My personal setup, **don't use the install script unless you're me**. I recommend looking through the files and picking bits and pieces that fit your workflows.

## Setup

To install the dotfiles in your `$HOME` directory, run:

```sh
curl -Ls benelan.dev/d | sh
```
Use the [`dot`](.dotfiles/bin/dot) script's `setup` command if the link above dies. The script will backup any conflicting files to `~/.dotfiles-backup`. It will set up the dotfiles as a bare git repo to make syncing changes much easier. Read [this tutorial](https://www.atlassian.com/git/tutorials/dotfiles) for more info. A common alternative is managing dotfiles with symlinks (e.g. GNU stow), but in my experience that can get messy.

You can use [`dot`](.dotfiles/bin/dot) like `git` and the arguments will be passed to `git` with environment variables set to ensure `dot` always acts on the bare repo. Untracked files are hidden, so you will need to manually add files before they show up in the status/diff. A typical workflow for adding a new configuration to the repo is:

```sh
dot add .config/xyz/config.yml
dot commit -m "chore(xyz): add config"
dot push
```

[Git bash completion](.dotfiles/shell/completions/2_git.completion.sh) and the git aliases defined at the bottom of [`~/.config/git/config`](.config/git/config) will also work for `dot`.

My setup was primarily created for use in Ubuntu/Debian and their derivative distros, but it worked in Fedora and should work in other Unix operating systems as well. I try to separate the Ubuntu-only code and make sure executables exist before using them. Vanilla Windows won't work, but WSL running Ubuntu does.

The `dot` script also has a `deps` command for installing various dependencies, including development tools, GUI apps, shell scripts, fonts, themes, and more. See `dot deps -h` for usage information.

> **NOTE:** I slimmed down recently, but checkout (pun intended) the `extras` branch for more goodies.

## Configuration

Put machine-specific stuff in `~/.dotfiles/shell/local.sh`, which gets sourced in [`~/.bashrc`](.bashrc) if it exists. The following environment variables are flags that accept a value of `1` or `0` (default) to turn on/off different tools:

- `USE_GUI_APPS` - Install and use tools that only work on desktop machines.
- `USE_WORK_STUFF` - Setup the environment for work.
- `USE_COPILOT` - Use the GitHub Copilot plugin in Neovim.
- `USE_CODEIUM` - Use the Codeium (free Copilot alternative) plugin in Neovim.
- `USE_DEVICONS` - Use developer icons in various tools. The icons are displayed in Neovim/Vim/Vifm by default when using Wezterm (since it [ships with Nerd Font glyphs](https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html)), but they can be disabled by setting the option to `0`. Make sure to [install a Nerd Font](https://www.nerdfonts.com/) (e.g. `dot deps -t font`) before enabling the option if you don't use Wezterm.

---

## MIT License

Copyright 2022-present (c) Ben Elan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

### Credits

I learned and stole a lot from the following sources. There are credits/links in specific files as well.

- Copyright (c) 2020-2021 Bash-it `MIT` [[code](https://github.com/Bash-it/bash-it)]

- Copyright (c) 2014 "Cowboy" Ben Alman `MIT` [[code](https://github.com/cowboy/dotfiles)]

- Tom Ryder `UNLICENSE` [[code](https://dev.sanctum.geek.nz/cgit/dotfiles.git/tree/)]
