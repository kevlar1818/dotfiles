dotfiles
========

My contribution to the world of config file management repos.

Features
--------
##### Multi-configuartion support
* Use git branches to create configurations for different projects, platforms, etc.
* Branches can be standalone, or they can inherit from each other; it's as complex as you choose.

##### Flexible syncing
* Sync one, some, or all of your config files with globs.
* Dotfiles makes backups of local config files if you ever want to revert changes.

Usage
-----
```
usage: dotfiles.sh [options] [file] ...

Author: Kevin Hanselman | www.github.com/kevlar1818/dotfiles

Positional Arguments:
  file(s)       attempts to link only the glob/file(s)

Options:
  -h            show this help text and exit
  -y            don't ask for confirmation
```

Prerequisites
-------------
* `bash`
* `git`

Thanks to
---------
[John Anderson's dotfiles](https://github.com/sontek/dotfiles)
[Mathias Bynens's dotfiles](https://github.com/mathiasbynens/dotfiles)

