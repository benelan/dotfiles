# dotfiles

My personal setup, **don't use the install script unless you're me**. I recommend looking through the files and picking bits and pieces that fit your workflows.

To install the dotfiles in your `$HOME` directory, run:

```sh
bash <(curl -s https://raw.githubusercontent.com/benelan/dotfiles/master/.dotfiles/scripts/dotfiles.init.bash)
```

The script will backup any conflicting files to `~/.dotfiles-backup`. It will setup a bare git repo to make syncing changes much easier. For more info, I found the idea on a [Hacker News thread](https://news.ycombinator.com/item?id=11071754). A common alternative is managing dotfiles with symlinks, but in my experience that gets messy when making frequent improvements.

An alias `dot`, which works like `git`, allows you to manage dotfiles from any directory on a machine. It is set up to hide untracked files, so you will need to manually add files before they show up in the status/diff. A typical workflow for adding a new configuration to the repo is:

```sh
dot add .config/xyz/config.yml
dot commit -m "chore(xyz): add config"
dot push
```

A set of aliases for `git` and `dot` are provided in [`.dotfiles/sh/aliases/git.alias.sh`](https://github.com/benelan/dotfiles/blob/master/.dotfiles/sh/aliases/git.alias.sh).

My setup was primarily created for use in Ubuntu/Debian based distros, but it worked in Fedora and should work in other Linux distros and OSX as well. Vanilla Windows won't work, but WSL running Ubuntu does.

If you are on Ubuntu, running [`deps-apt.init.bash`](https://github.com/benelan/dotfiles/blob/master/.dotfiles/scripts/deps-apt.init.bash) will install some useful dependencies that are used throughout the dotfiles. There is also a platform agnostic [`deps.init.bash`](https://github.com/benelan/dotfiles/blob/master/.dotfiles/scripts/deps.init.bash) script, which installs the Go and Cargo tools I commonly use, as well as some other stuff like fonts.

---

## License

Copyright (c) 2022 Ben Elan `GPLv3`

The GPLv3 License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details <http://www.gnu.org/licenses/>.

### Credits

I learned and stole a lot from the following sources. There are credits/links in specific files as well.

- Copyright (c) 2020-2021 Bash-it `MIT` [[code](https://github.com/Bash-it/bash-it)]

- Copyright (c) 2014 "Cowboy" Ben Alman `MIT` [[code](https://github.com/cowboy/dotfiles)]

- Copyright Mathias Bynens `MIT` [[code](https://github.com/mathiasbynens/dotfiles)]

- Tom Ryder `UNLICENSE` [[code](https://dev.sanctum.geek.nz/cgit/dotfiles.git/tree/)]
