#!/usr/bin/env bash
set -e

echo "======================================"
echo " CI/CD local pipeline for main_word"
echo "======================================"

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_ROOT"

echo
echo "[1/4] Build program"
./cicd/build.sh

echo
echo "[2/4] Run tests"
./cicd/test.sh

echo
echo "[3/4] Build .deb package"
./cicd/package_deb.sh

echo
echo "[4/4] Install .deb package (optional for  test)"
DEB_FILE=$(ls dist/*.deb 2>/dev/null | tail -n 1)

if [ -f "$DEB_FILE" ]; then
    echo "Installing: $DEB_FILE"
    sudo dpkg -i "$DEB_FILE" || sudo apt -f install -y
else
    echo "No .deb file found in dist/"
    exit 1
fi

echo
echo "======================================"
echo " Pipeline finished successfully ✔"
echo "======================================"

