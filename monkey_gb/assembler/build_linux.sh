#!/bin/bash
# This script clears the terminal, displays a greeting and copies the
# relevant files from the uNabto submodule. It then deletes the remaining files.

rgbasm -ogame.obj game.z80
rgblink -mgame.map -ngame.sym -ogame.gb game.obj
rgbfix -p0 -v game.gb
