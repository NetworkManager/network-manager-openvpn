#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir="$(dirname "$0")"
test -z "$srcdir" && srcdir=.
REQUIRED_AUTOMAKE_VERSION=1.9
PKG_NAME=NetworkManager-openvpn

{ test -f "$srcdir/configure.ac" \
  && test -f "$srcdir/auth-dialog/main.c"; } || {
    echo "**Error**: Directory ${srcdir} does not look like the top-level ${PKG_NAME} directory"
    exit 1
}

for test_tool in autoreconf intltoolize
do
	[ -x "$(command -v "$test_tool")" ] || {
		echo "${test_tool} was not found!"
		exit 1
	}
done

if cd "$srcdir"; then
    autoreconf --install --symlink
    intltoolize --force
    autoreconf
    [ -n "$NOCONFIGURE" ] && ./configure --enable-maintainer-mode "$@"
fi
