#!/usr/bin/env bash
set -euo pipefail

NAME="main-word"     # имя пакета 
BINNAME="main_word"  # имя бинаря 
ARCH="amd64"         # для раннера 
SECTION="utils"
PRIORITY="optional"
MAINTAINER="Studentka Xenium <zo71105@voenmeh.ru>"
DEPENDS="libc6"

SHA="${GITHUB_SHA:-$(git rev-parse --short HEAD 2>/dev/null || echo local)}"
VERSION="${GITHUB_REF_NAME:-0.1.0}-${SHA}"

ROOT="package"
OUTDIR="dist"
BIN_SRC="./usr/bin/${BINNAME}"

rm -rf "$ROOT" "$OUTDIR"
mkdir -p "$ROOT/DEBIAN" "$ROOT/usr/bin" "$OUTDIR"

install -m 0755 "$BIN_SRC" "$ROOT/usr/bin/$BINNAME"

SIZE_KB="$(du -sk "$ROOT/usr" | awk '{print $1}')"

cat > "$ROOT/DEBIAN/control" <<EOF
Package: ${NAME}
Version: ${VERSION}
Section: ${SECTION}
Priority: ${PRIORITY}
Architecture: ${ARCH}
Depends: ${DEPENDS}
Installed-Size: ${SIZE_KB}
Maintainer: ${MAINTAINER}
Description: Program that counts number of words in a string.
EOF

dpkg-deb --build "$ROOT" "$OUTDIR/${NAME}_${VERSION}_${ARCH}.deb"
echo "[package] created: $OUTDIR/${NAME}_${VERSION}_${ARCH}.deb"

