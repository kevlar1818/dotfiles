#!/usr/bin/env bash

# utility functions
confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Continue? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY])
            echo true
            ;;
        *)
            echo false
            ;;
    esac
}

link_file() {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ ! -e "$source" ]; then
        echo "File '$source' not found." >&2
        exit 1
    fi

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        [ -n "$2" ] && echo "Backing up $target"
        mv $target $target.df.bak
    fi

    #[ -n "$2" ] && echo "L: $1 -> $target"
    ln -sf $2 $source $target
}

unlink_file() {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -L "$target" ]; then
        #[ -n "$2" ] && echo "Removing '$target'."
        rm $2 $target
        if [ -e "$target.df.bak" ]; then
            [ -n "$2" ] && echo "Restoring from '$target.df.bak'."
            mv $target.df.bak $target
        fi
    fi
}

usage() {
    echo -e "usage: `basename $0` [options] [file ... ]\n"
    echo -e "Configuration file manager"
    echo -e "Author: Kevin Hanselman | www.github.com/kevlar1818/dotfiles"
    echo -e "\nArguments:"
    echo -e "  file(s)\tattempts to link only the glob/file(s)"
    echo -e "  \t\t (defaults to all files matching the glob '_*')"
    echo -e "\nOptions:"
    echo -e "  -h\t\tshow this help text and exit"
    echo -e "  -r\t\tremove symlinks and restore backups if present"
    echo -e "  -x\t\tall excluding '[file] ...' (ignored if no file args)"
    echo -e "  -y\t\tdon't ask for confirmation"
    echo -e "  -q\t\tquiet mode/suppress output"
}

verbose="-v"
while getopts ":h :y :x :r :q" opt; do
    case $opt in
        h)
            usage
            exit 0
            ;;
        y)
            ask=false
            ;;
        x)
            exclude=true
            ;;
        r)
            restore=true
            ;;
        q)
            verbose=
            ;;
        \?)
            echo -e "Invalid option: -$OPTARG\n" >&2
            usage
            exit 1
            ;;
        :)
            echo -e "Option -$OPTARG requires an argument.\n" >&2
            usage
            exit 1
            ;;
    esac
done

branch=`basename \`git symbolic-ref HEAD\``
echo "Using the '$branch' configuration."
if [ -z "$ask" ]; then
    confirm=`confirm`
else
    confirm=true
fi
if [ "$confirm" != "true" ]; then
    echo "Use 'git checkout' to switch branches/configurations."
    exit 0
fi

shift $(($OPTIND-1))

if [ -n "$*" ] && [ -z "$exclude" ]; then
    files=$@
else
    files=_*
fi
for i in $files; do
    if [ -n "$exclude" ] && [[ $* == *"$i"* ]]; then
        [ -n "$verbose" ] && echo "skipping '$i'"
        continue
    fi
    if [ -d "$i" ]; then    # if a directory, link it's files
        newdir="${HOME}/${i/_/.}"
        mkdir -p "$verbose" "$newdir" # create the directory if needed
        for f in `basename $i`/*; do
            if [ -n "$restore" ]; then
                unlink_file "$f" "$verbose"
            else
                link_file "$f" "$verbose"
            fi
        done
    elif [ -n "$restore" ]; then
        unlink_file "$i" "$verbose"
    else
        link_file "$i" "$verbose"
    fi
done

