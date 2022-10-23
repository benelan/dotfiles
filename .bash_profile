#! /bin/sh

# Load ~/.profile regardless of shell version
if [ -e "$HOME"/.profile ] ; then
    . "$HOME"/.profile
fi

# If POSIXLY_CORRECT is set after doing that, force the `posix` option on and
# don't load the rest of this stuff
if [ -n "$POSIXLY_CORRECT" ] ; then
    set -o posix
    return
fi


# If ~/.bashrc exists, source that too; the tests for both interactivity and
# minimum version numbers are in there
if [ -f "$HOME"/.bashrc ] ; then
    . "$HOME"/.bashrc
fi
