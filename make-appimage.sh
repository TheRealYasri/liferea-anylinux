#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
VERSION=$(sed -nE "s/.*(^|[[:space:],])version:[[:space:]]*'([^']+)'.*/\2/p" liferea/meson.build | head -n 1)
export VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/liferea/icons/hicolor/scalable/net.sourceforge.liferea.svg
export DESKTOP=/usr/share/applications/net.sourceforge.liferea.desktop
export PATH_MAPPING='/usr/share/liferea:${SHARUN_DIR}/share/liferea,/usr/share/glib-2.0/schemas:${SHARUN_DIR}/share/glib-2.0/schemas'
export DEPLOY_PYTHON=1
export DEPLOY_GTK=1
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun \
    /usr/bin/liferea \
    /usr/bin/xdg-dbus-proxy \
    /usr/lib/liferea \
    /usr/lib/libpeas-2 \
    /usr/lib/webkitgtk-6.0/* \
    /usr/share/liferea \
    /usr/share/glib-2.0/schemas \
    /usr/lib/libpeas-2.so* \
    /usr/lib/libwebkitgtk-6.0.so* \
    /usr/lib/libadwaita-1.so*

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
# quick-sharun --test ./dist/*.AppImage
