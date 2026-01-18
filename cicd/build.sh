#!/usr/bin/env bash
set -euo pipefail

echo "[build] start"
cd src
make clean
make

test -f ./main_word

mkdir -p ../usr/bin
cp -v ./main_word ../usr/bin/main_word
echo "[build] done"

