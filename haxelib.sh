#!/bin/sh
haxe compile.hxml
exec neko jit "$@"
