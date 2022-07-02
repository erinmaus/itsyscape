set -e

compile_lua_resource() {
	echo "return " > $1.tmp
	cat $1 >> $1.tmp
	${LUAJIT} -bs $1.tmp $1.cache
	rm $1.tmp
	echo "Built $1"
}

export LUAJIT="${LUAJIT:=luajit}"
export -f compile_lua_resource

find . -name '*.lmodel' -exec sh -c 'compile_lua_resource "$0"' {} \;
find . -name '*.lmesh' -exec sh -c 'compile_lua_resource "$0"' {} \;
find . -name '*.lstatic' -exec sh -c 'compile_lua_resource "$0"' {} \;
find . -name '*.lmap' -exec sh -c 'compile_lua_resource "$0"' {} \;
