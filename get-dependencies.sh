#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    meson ninja gcc pkgconf git \
    glib2 gtk4 libadwaita json-glib libxml2 libxslt sqlite \
    webkitgtk-6.0 libpeas-2 python-gobject pango fribidi \
    gobject-introspection gsettings-desktop-schemas \
    desktop-file-utils appstream intltool python-requests

echo "Compiling and installing Liferea..."
echo "---------------------------------------------------------------"
git clone --depth 1 https://github.com/lwindolf/liferea.git
cd liferea
meson setup build --prefix=/usr
meson compile -C build
meson install -C build
cd ..

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
