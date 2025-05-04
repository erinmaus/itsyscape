#!/bin/bash

set -e

compile_lua_resource() {
	echo "return " > $1.tmp
	cat $1 >> $1.tmp
	${LUAJIT} -e "local buffer = require 'string.buffer'; local result = dofile('$1.tmp'); local f = io.open('$1.cache', 'wb+'); f:write(buffer.encode(result)); f:close();"
	rm $1.tmp
	echo "Built $1"
}

export LUAJIT="${LUAJIT:=luajit}"
export -f compile_lua_resource

find . -name '*.lmodel' -exec bash -c 'compile_lua_resource "$0"' {} \;
find . -name '*.lmesh' -exec bash -c 'compile_lua_resource "$0"' {} \;
find . -name '*.lstatic' -exec bash -c 'compile_lua_resource "$0"' {} \;
find . -name '*.lmap' -exec bash -c 'compile_lua_resource "$0"' {} \;
