# dotfiles

My personal setup, __don't use without looking through the configuration__. To install the dotfiles in your `$HOME` directory, run:

```sh
bash <(curl -s https://raw.githubusercontent.com/benelan/dotfiles/master/.dotfiles/scripts/dotfiles.init.bash)
```

The script will backup any conflicting files to `~/.dotfiles-backup`. It will setup a bare git repo, for more info I found the idea on a [Hacker News thread](https://news.ycombinator.com/item?id=11071754).

An alias `dot`, which works like `git`, allows you to manage dotfiles from any directory on a machine. It is set up to not show untracked files, so you will need to add files manually for them to show up in the status/diff. A typical workflow for adding a new configuration to the repo is:

```sh
dot add .config/xyz/config.yml
dot commit -m "chore(xyz): add config"
dot push
```

A set of aliases for `git` and `dot` are provided in [`.dotfiles/sh/aliases/git.alias.sh`](https://github.com/benelan/dotfiles/blob/master/.dotfiles/sh/aliases/git.alias.sh).

My setup was primarily created for use in Ubuntu/Debian based distros, but it worked in Fedora and should work in other Linux distros and OSX as well. Vanilla Windows won't work, but WSL running Ubuntu does.
