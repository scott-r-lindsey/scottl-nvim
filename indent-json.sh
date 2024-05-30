#!/bin/sh

if which python3 >/dev/null; then
    python3 -m json.tool --sort-keys $1
else
    python -m json.tool --sort-keys $1
fi
