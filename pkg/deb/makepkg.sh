#!/bin/bash
#
# Debian Build script for the WaTTS info plugin
#
# Under any dpkg based distro (e.g. Ubuntu) run:
#  $ ./makepkg.sh
#
# Maintainer: Joshua Bachmeier <uwdkl@student.kit.edu>
#

pkgname=watts-plugin-info
_pkgname=tts_plugin_info
pkgver=1.1.0
pkgrel=1

srcdir=$(readlink -f ${_pkgname}-${pkgver})
pkgdir=$(readlink -f ${pkgname}_${pkgver}-${pkgrel})


[[ ! -f "v${pkgver}.tar.gz" ]] && \
    wget "https://github.com/joshuabach/${_pkgname}/archive/v${pkgver}.tar.gz"
tar xf "v${pkgver}.tar.gz"
mkdir -p "${pkgdir}"

# Debian stuff
mkdir -p "${pkgdir}/DEBIAN"
sed -e "s/%package/${pkgname}/" \
    -e "s/%version/${pkgver}-${pkgrel}/" \
    < control.template > "${pkgdir}/DEBIAN/control"

# Package
pushd "${srcdir}"
mkdir -p "${pkgdir}/var/lib/watts/plugins"
install -m733 -t "${pkgdir}/var/lib/watts/plugins" plugin/info.py
popd

# Finale
dpkg-deb --build ${pkgname}_${pkgver}-${pkgrel}
