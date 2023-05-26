# dotfiles

My personal setup, **don't use the install script unless you're me**. I recommend looking through the files and picking bits and pieces that fit your workflows.

To install the dotfiles in your `$HOME` directory, run:

```sh
bash <(curl -s https://raw.githubusercontent.com/benelan/dotfiles/master/.dotfiles/scripts/dotfiles.init.sh)
```

The script will backup any conflicting files to `~/.dotfiles-backup`. It will setup a bare git repo to make syncing changes much easier. For more info, I found the idea on a [Hacker News thread](https://news.ycombinator.com/item?id=11071754). A common alternative is managing dotfiles with symlinks, but in my experience that gets messy when making frequent improvements.

An alias `dot`, which works like `git`, allows you to manage dotfiles from any directory on a machine. It is set up to hide untracked files, so you will need to manually add files before they show up in the status/diff. A typical workflow for adding a new configuration to the repo is:

```sh
dot add .config/xyz/config.yml
dot commit -m "chore(xyz): add config"
dot push
```

A set of aliases for `git` and `dot` are provided in [`.dotfiles/shell/aliases.sh`](https://github.com/benelan/dotfiles/blob/master/.dotfiles/shell/aliases.sh).

My setup was primarily created for use in Ubuntu/Debian based distros, but it worked in Fedora and should work in other Linux distros and OSX as well. Vanilla Windows won't work, but WSL running Ubuntu does.

There is also a [`deps.init.sh`](https://github.com/benelan/dotfiles/blob/master/.dotfiles/scripts/deps.init.sh) script, which installs a lot of the development tools I commonly use, as well as some other stuff like fonts.

---

## MIT License

Copyright (c) Ben Elan

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
