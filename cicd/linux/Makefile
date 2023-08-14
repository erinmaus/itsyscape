# Makefile script to generate AppImage for LOVE

# Number of processor to use when compiling
NUMBER_OF_PROCESSORS := $(shell nproc)

# CPU architecture, defaults to host
ARCH := $(shell uname -m)

# CMake URL
CMAKE_URL := https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2-linux-$(shell uname -m).sh

# Project branches (for git-based projects)
LOVE_BRANCH := master
SDL2_BRANCH := release-2.0.22
LUAJIT_BRANCH := v2.1
OPENAL_BRANCH := 1.22.0
BROTLI_BRANCH := v1.0.9
ZLIB_BRANCH := v1.2.12

# Project versions (for downloadable tars)
LIBOGG_VERSION := 1.3.5
LIBVORBIS_VERSION := 1.3.7
LIBTHEORA_VERSION := 1.2.0alpha1
LIBPNG_VERSION := 1.6.37
FT_VERSION := 2.12.1
BZIP2_VERSION := 1.0.8
MPG123_VERSION := 1.29.3
LIBMODPLUG_VERSION := 0.8.8.5

# Output AppImage
APPIMAGE_OUTPUT := love-$(LOVE_BRANCH).AppImage

# No need to change anything beyond this line
override INSTALLPREFIX := $(CURDIR)/installdir

override CMAKE_PREFIX := $(CURDIR)/cmake
CMAKE := $(CMAKE_PREFIX)/bin/cmake
override CMAKE_OPTS := -DCMAKE_INSTALL_RPATH='$$ORIGIN/../lib' -DCMAKE_INSTALL_PREFIX=$(INSTALLPREFIX)
override CONFIGURE := LDFLAGS="-Wl,-rpath,'\$$\$$ORIGIN/../lib' $$LDFLAGS" ../configure --prefix=$(INSTALLPREFIX)

# CMake setup
ifeq ($(SYSTEM_CMAKE),)
cmake_install.sh:
	curl -Lo cmake_install.sh $(CMAKE_URL)
	chmod u+x cmake_install.sh

$(CMAKE): cmake_install.sh
	mkdir cmake
	bash cmake_install.sh --prefix=$(CMAKE_PREFIX) --skip-license
	touch $(CMAKE)
else
CMAKE := $(CURDIR)/cmakewrapper.sh

$(CMAKE):
	which cmake
	echo $(shell which cmake) '$$@' > $(CMAKE)
	chmod u+x $(CMAKE)
endif

cmake: $(CMAKE)

# AppImageTool
appimagetool:
	curl -Lo appimagetool https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$(ARCH).AppImage
	chmod u+x appimagetool
ifneq ($(QEMU),)
# Extract the AppImageTool
	$(QEMU) ./appimagetool --appimage-extract
endif

# SDL2
override SDL2_PATH := SDL2-$(SDL2_BRANCH)

$(SDL2_PATH)/configure:
	git clone --depth 1 -b $(SDL2_BRANCH) https://github.com/libsdl-org/SDL $(SDL2_PATH)

$(SDL2_PATH)/build/Makefile: $(SDL2_PATH)/configure
	mkdir -p $(SDL2_PATH)/build
	cd $(SDL2_PATH)/build && $(CONFIGURE) --disable-video-wayland

installdir/lib/libSDL2.so: $(SDL2_PATH)/build/Makefile
	cd $(SDL2_PATH)/build && $(MAKE) install -j$(NUMBER_OF_PROCESSORS)
	strip installdir/lib/libSDL2.so

# libogg
override LIBOGG_FILE := libogg-$(LIBOGG_VERSION)

$(LIBOGG_FILE).tar.gz:
	curl -Lo $(LIBOGG_FILE).tar.gz http://downloads.xiph.org/releases/ogg/$(LIBOGG_FILE).tar.gz

$(LIBOGG_FILE)/configure: $(LIBOGG_FILE).tar.gz
	tar xzf $(LIBOGG_FILE).tar.gz
	touch $(LIBOGG_FILE)/configure

$(LIBOGG_FILE)/build/Makefile: $(LIBOGG_FILE)/configure
	mkdir -p $(LIBOGG_FILE)/build
	cd $(LIBOGG_FILE)/build && $(CONFIGURE)

installdir/lib/libogg.so: $(LIBOGG_FILE)/build/Makefile
	cd $(LIBOGG_FILE)/build && $(MAKE) install -j$(NUMBER_OF_PROCESSORS)
	strip installdir/lib/libogg.so

# libvorbis
override LIBVORBIS_FILE := libvorbis-$(LIBVORBIS_VERSION)

$(LIBVORBIS_FILE).tar.gz:
	curl -Lo $(LIBVORBIS_FILE).tar.gz http://downloads.xiph.org/releases/vorbis/$(LIBVORBIS_FILE).tar.gz

$(LIBVORBIS_FILE)/configure: $(LIBVORBIS_FILE).tar.gz
	tar xzf $(LIBVORBIS_FILE).tar.gz
	touch $(LIBVORBIS_FILE)/configure

$(LIBVORBIS_FILE)/build/Makefile: $(LIBVORBIS_FILE)/configure installdir/lib/libogg.so
	mkdir -p $(LIBVORBIS_FILE)/build
	cd $(LIBVORBIS_FILE)/build && $(CONFIGURE)

installdir/lib/libvorbis.so: $(LIBVORBIS_FILE)/build/Makefile
	cd $(LIBVORBIS_FILE)/build && $(MAKE) install -j$(NUMBER_OF_PROCESSORS)
	strip installdir/lib/libvorbis.so
	strip installdir/lib/libvorbisfile.so
	strip installdir/lib/libvorbisenc.so

# libtheora
override LIBTHEORA_FILE := libtheora-$(LIBTHEORA_VERSION)

$(LIBTHEORA_FILE).tar.gz:
	curl -Lo $(LIBTHEORA_FILE).tar.gz http://downloads.xiph.org/releases/theora/$(LIBTHEORA_FILE).tar.gz

$(LIBTHEORA_FILE)/configure: $(LIBTHEORA_FILE).tar.gz
	tar xzf $(LIBTHEORA_FILE).tar.gz
# Their config.guess and config.sub can't detect ARM64
ifeq ($(ARCH),aarch64)
	curl -o $(LIBTHEORA_FILE)/config.guess "https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD"
	chmod u+x $(LIBTHEORA_FILE)/config.guess
	curl -o $(LIBTHEORA_FILE)/config.sub "https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD"
	chmod u+x $(LIBTHEORA_FILE)/config.sub
endif
	touch $(LIBTHEORA_FILE)/configure

$(LIBTHEORA_FILE)/build/Makefile: $(LIBTHEORA_FILE)/configure installdir/lib/libogg.so
	mkdir -p $(LIBTHEORA_FILE)/build
	cd $(LIBTHEORA_FILE)/build && $(CONFIGURE) --with-ogg=$(INSTALLPREFIX) --with-vorbis=$(INSTALLPREFIX) --disable-examples --disable-encode

installdir/lib/libtheora.so: $(LIBTHEORA_FILE)/build/Makefile
	cd $(LIBTHEORA_FILE)/build && $(MAKE) install -j $(NUMBER_OF_PROCESSORS)
	strip installdir/lib/libtheora.so
	strip installdir/lib/libtheoradec.so
	strip installdir/lib/libtheoraenc.so

# zlib
override ZLIB_PATH := zlib-$(ZLIB_BRANCH)

$(ZLIB_PATH)/configure:
	git clone --depth 1 -b $(ZLIB_BRANCH) https://github.com/madler/zlib $(ZLIB_PATH)

$(ZLIB_PATH)/build/Makefile: $(ZLIB_PATH)/configure
	mkdir -p $(ZLIB_PATH)/build
	cd $(ZLIB_PATH)/build && $(CONFIGURE)

installdir/lib/libz.so: $(ZLIB_PATH)/build/Makefile
	cd $(ZLIB_PATH)/build && $(MAKE) install -j$(NUMBER_OF_PROCESSORS)
	strip installdir/lib/libz.so

# libpng
override LIBPNG_FILE := libpng-$(LIBPNG_VERSION)

$(LIBPNG_FILE).tar.gz:
	curl -Lo $(LIBPNG_FILE).tar.gz http://prdownloads.sourceforge.net/libpng/$(LIBPNG_FILE).tar.gz?download

$(LIBPNG_FILE)/configure: $(LIBPNG_FILE).tar.gz
	tar xzf $(LIBPNG_FILE).tar.gz
	touch $(LIBPNG_FILE)/configure

$(LIBPNG_FILE)/build/Makefile: $(LIBPNG_FILE)/configure installdir/lib/libz.so
	mkdir -p $(LIBPNG_FILE)/build
	cd $(LIBPNG_FILE)/build && LDFLAGS="-L$(INSTALLPREFIX)/lib" CFLAGS="-I$(INSTALLPREFIX)/include" CPPFLAGS="-I$(INSTALLPREFIX)/include" $(CONFIGURE)

installdir/lib/libpng16.so: $(LIBPNG_FILE)/build/Makefile
	cd $(LIBPNG_FILE)/build && CFLAGS="-I$(INSTALLPREFIX)/include" $(MAKE) install -j$(NUMBER_OF_PROCESSORS)
	strip installdir/lib/libpng16.so

# Brotli
override BROTLI_PATH := brotli-$(BROTLI_BRANCH)

$(BROTLI_PATH)/CMakeLists.txt:
	git clone --depth 1 -b $(BROTLI_BRANCH) https://github.com/google/brotli $(BROTLI_PATH)

$(BROTLI_PATH)/build/CMakeCache.txt: $(CMAKE) $(BROTLI_PATH)/CMakeLists.txt
	rm -f ${BROTLI_PATH}/BUILD
	rm -rf ${BROTLI_PATH}/build
	mkdir -p ${BROTLI_PATH}/build
	$(CMAKE) -B$(BROTLI_PATH)/build -H$(BROTLI_PATH) $(CMAKE_OPTS)

installdir/lib/libbrotlidec.so: $(BROTLI_PATH)/build/CMakeCache.txt
	$(CMAKE) --build $(BROTLI_PATH)/build --target install -j $(NUMBER_OF_PROCESSORS)
	strip installdir/lib/libbrotlicommon.so
	strip installdir/lib/libbrotlidec.so
	strip installdir/lib/libbrotlienc.so

# OpenAL-soft
override OPENAL_PATH := openal-soft-$(OPENAL_BRANCH)

$(OPENAL_PATH)/CMakeLists.txt:
	git clone --depth 1 -b $(OPENAL_BRANCH) https://github.com/kcat/openal-soft $(OPENAL_PATH)

$(OPENAL_PATH)/build/CMakeCache.txt: $(CMAKE) $(OPENAL_PATH)/CMakeLists.txt
	$(CMAKE) -B$(OPENAL_PATH)/build -H$(OPENAL_PATH) $(CMAKE_OPTS) -DALSOFT_EXAMPLES=0 -DALSOFT_BACKEND_SNDIO=0

installdir/lib/libopenal.so: $(OPENAL_PATH)/build/CMakeCache.txt
	$(CMAKE) --build $(OPENAL_PATH)/build --target install -j $(NUMBER_OF_PROCESSORS)
	strip installdir/lib/libopenal.so

# BZip2
override BZIP2_FILE := bzip2-$(BZIP2_VERSION)

$(BZIP2_FILE).tar.gz:
	curl -Lo $(BZIP2_FILE).tar.gz https://sourceware.org/pub/bzip2/$(BZIP2_FILE).tar.gz

$(BZIP2_FILE)/Makefile: $(BZIP2_FILE).tar.gz
	tar xzf $(BZIP2_FILE).tar.gz
	touch $(BZIP2_FILE)/Makefile

installdir/bzip2installed.txt: $(BZIP2_FILE)/Makefile
	cd $(BZIP2_FILE) && $(MAKE) install -j$(NUMBER_OF_PROCESSORS) CFLAGS="-fPIC -Wall -Winline -O2 -g -D_FILE_OFFSET_BITS=64" LDFLAGS="-Wl,-rpath,'\$ORIGIN/../lib'" PREFIX=$(INSTALLPREFIX)
	touch installdir/bzip2installed.txt

# FreeType
override FT_FILE := freetype-$(FT_VERSION)

$(FT_FILE).tar.gz:
	curl -Lo $(FT_FILE).tar.gz https://download.savannah.gnu.org/releases/freetype/$(FT_FILE).tar.gz

$(FT_FILE)/configure: $(FT_FILE).tar.gz
	tar xzf $(FT_FILE).tar.gz
	touch $(FT_FILE)/configure

$(FT_FILE)/build/Makefile: $(FT_FILE)/configure installdir/bzip2installed.txt installdir/lib/libpng16.so installdir/lib/libz.so installdir/lib/libbrotlidec.so
	mkdir -p $(FT_FILE)/build
	cd $(FT_FILE)/build && CFLAGS="-I$(INSTALLPREFIX)/include" LDFLAGS="-Wl,-rpath,'\$$\$$ORIGIN/../lib' -L$(INSTALLPREFIX)/lib -Wl,--no-undefined" PKG_CONFIG_PATH=$(INSTALLPREFIX)/lib/pkgconfig ../configure --prefix=$(INSTALLPREFIX)

installdir/lib/libfreetype.so: $(FT_FILE)/build/Makefile
	cd $(FT_FILE)/build && $(MAKE) install -j$(NUMBER_OF_PROCESSORS)
	strip installdir/lib/libfreetype.so

# Mpg123
override MPG123_FILE := mpg123-$(MPG123_VERSION)

$(MPG123_FILE).tar.bz2:
	curl -Lo $(MPG123_FILE).tar.bz2 https://www.mpg123.de/download/$(MPG123_FILE).tar.bz2

$(MPG123_FILE)/configure: $(MPG123_FILE).tar.bz2
	tar xf $(MPG123_FILE).tar.bz2
	touch $(MPG123_FILE)/configure

$(MPG123_FILE)/builddir/Makefile: $(MPG123_FILE)/configure
	mkdir -p $(MPG123_FILE)/builddir
	cd $(MPG123_FILE)/builddir && $(CONFIGURE)

installdir/lib/libmpg123.so: $(MPG123_FILE)/builddir/Makefile
	cd $(MPG123_FILE)/builddir && $(MAKE) install -j$(NUMBER_OF_PROCESSORS)
	strip installdir/lib/libmpg123.so

# libmodplug
override LIBMODPLUG_FILE := libmodplug-$(LIBMODPLUG_VERSION)

$(LIBMODPLUG_FILE).tar.gz:
	curl -Lo $(LIBMODPLUG_FILE).tar.gz http://sourceforge.net/projects/modplug-xmms/files/libmodplug/$(LIBMODPLUG_VERSION)/$(LIBMODPLUG_FILE).tar.gz/download

$(LIBMODPLUG_FILE)/configure: $(LIBMODPLUG_FILE).tar.gz
	tar xzf $(LIBMODPLUG_FILE).tar.gz
	touch $(LIBMODPLUG_FILE)/configure

$(LIBMODPLUG_FILE)/build/Makefile: $(LIBMODPLUG_FILE)/configure
	mkdir -p $(LIBMODPLUG_FILE)/build
	cd $(LIBMODPLUG_FILE)/build && $(CONFIGURE)

installdir/lib/libmodplug.so: $(LIBMODPLUG_FILE)/build/Makefile
	cd $(LIBMODPLUG_FILE)/build && $(MAKE) install -j$(NUMBER_OF_PROCESSORS)

# LuaJIT
override LUAJIT_PATH := LuaJIT-$(LUAJIT_BRANCH)

$(LUAJIT_PATH)/Makefile:
	git clone --depth 1 -b $(LUAJIT_BRANCH) https://github.com/LuaJIT/LuaJIT $(LUAJIT_PATH)

installdir/lib/libluajit-5.1.so: $(LUAJIT_PATH)/Makefile
	cd $(LUAJIT_PATH) && LDFLAGS="-Wl,-rpath,'\$$\$$ORIGIN/../lib'" $(MAKE) amalg -j$(NUMBER_OF_PROCESSORS) PREFIX=/usr
	cd $(LUAJIT_PATH) && make install PREFIX=$(INSTALLPREFIX)
	cd $(LUAJIT_PATH) && make clean
	strip installdir/lib/libluajit-5.1.so
	strip installdir/bin/luaji*

# LOVE
override LOVE_PATH := love2d-$(LOVE_BRANCH)

$(LOVE_PATH)/CMakeLists.txt:
	git clone --depth 1 -b $(LOVE_BRANCH) https://github.com/love2d/love $(LOVE_PATH)

$(LOVE_PATH)/configure: $(LOVE_PATH)/CMakeLists.txt installdir/lib/libluajit-5.1.so installdir/lib/libmodplug.so installdir/lib/libmpg123.so installdir/lib/libfreetype.so installdir/lib/libopenal.so installdir/lib/libz.so installdir/lib/libtheora.so installdir/lib/libvorbis.so installdir/lib/libogg.so installdir/lib/libSDL2.so
	cd $(LOVE_PATH) && bash platform/unix/genmodules
	cp $(LOVE_PATH)/platform/unix/configure.ac $(LOVE_PATH) && cp $(LOVE_PATH)/platform/unix/Makefile.am $(LOVE_PATH)
	cd $(LOVE_PATH) && autoheader
	cd $(LOVE_PATH) && libtoolize --force
	cd $(LOVE_PATH) && aclocal -I $(INSTALLPREFIX)/share/aclocal
	cd $(LOVE_PATH) && autoconf -I$(INSTALLPREFIX)
	cd $(LOVE_PATH) && automake -a

$(LOVE_PATH)/build/Makefile: $(LOVE_PATH)/configure
	mkdir -p $(LOVE_PATH)/build
	cd $(LOVE_PATH)/build && CFLAGS="-I$(INSTALLPREFIX)/include" PKG_CONFIG_PATH=$(INSTALLPREFIX)/lib/pkgconfig LDFLAGS="-Wl,-rpath,'\$$\$$ORIGIN/../lib' -L$(INSTALLPREFIX)/lib" ../configure --prefix=$(INSTALLPREFIX)

installdir/bin/love: $(LOVE_PATH)/build/Makefile
	cd $(LOVE_PATH)/build && $(MAKE) install -j$(NUMBER_OF_PROCESSORS)
	strip installdir/bin/love
	-strip installdir/lib/liblove*

installdir/AppRun: AppRun.c installdir/bin/love
	$(CC) -o installdir/AppRun AppRun.c
	strip installdir/AppRun

installdir/love.desktop: $(LOVE_PATH)/platform/unix/love.desktop.in
	cat $(LOVE_PATH)/platform/unix/love.desktop.in | sed 's/@bindir@\///' > installdir/love.desktop

installdir/love.svg: $(LOVE_PATH)/platform/unix/love.svg
	cp $(LOVE_PATH)/platform/unix/love.svg installdir/love.svg

installdir/license.txt: $(LOVE_PATH)/license.txt
	cp $(LOVE_PATH)/license.txt installdir/license.txt

appimage-prepare: installdir/AppRun installdir/love.desktop installdir/love.svg installdir/license.txt appimagetool
	cp -r installdir installdir2
	-rm -rf installdir2/share/man
	-rm -rf installdir2/share/doc
	-rm -rf installdir2/share/openal
	-rm -rf installdir2/lib/mpg123
	-rm -rf installdir2/lib/cmake
	-rm -rf installdir2/lib/pkgconfig
	-rm -rf installdir2/lib/*.a
	-rm -rf installdir2/lib/*.la
	-rm -rf installdir2/lib/*.la
	-rm -rf installdir2/include
	-rm -rf installdir2/man
	-find installdir2/bin -type l -exec rm -rf {} +
	-find installdir2/bin ! -name 'luajit*' ! -name 'love' ! -name 'itsyrealm.love' -type f -exec rm -f {} +
	-strip installdir2/lib/*

$(APPIMAGE_OUTPUT): installdir/AppRun installdir/love.desktop installdir/love.svg installdir/license.txt appimagetool
	cp -r installdir installdir2
	-rm -rf installdir2/share/man
	-rm -rf installdir2/share/doc
	-rm -rf installdir2/share/openal
	-rm -rf installdir2/lib/mpg123
	-rm -rf installdir2/lib/cmake
	-rm -rf installdir2/lib/pkgconfig
	-rm -rf installdir2/lib/*.a
	-rm -rf installdir2/lib/*.la
	-rm -rf installdir2/lib/*.la
	-rm -rf installdir2/include
	-rm -rf installdir2/man
	-find installdir2/bin -type l -exec rm -rf {} +
	-find installdir2/bin ! -name 'luajit*' ! -name 'love' ! -name 'itsyrealm.love' -type f -exec rm -f {} +
	-strip installdir2/lib/*
ifeq ($(QEMU),)
	./appimagetool installdir2 $(APPIMAGE_OUTPUT)
else
	cd squashfs-root/usr/lib && ../../AppRun ../../../installdir2 ../../../$(APPIMAGE_OUTPUT)
endif
	rm -rf installdir2

getdeps: $(CMAKE) appimagetool $(SDL2_PATH)/configure $(LIBOGG_FILE).tar.gz $(LIBVORBIS_FILE).tar.gz $(LIBTHEORA_FILE).tar.gz $(ZLIB_PATH)/configure $(LIBPNG_FILE).tar.gz $(BROTLI_PATH)/CMakeLists.txt $(BZIP2_FILE).tar.gz $(FT_FILE).tar.gz $(MPG123_FILE).tar.bz2 $(LIBMODPLUG_FILE).tar.gz $(LUAJIT_PATH)/Makefile $(LOVE_PATH)/CMakeLists.txt

.DEFAULT_GOAL := $(APPIMAGE_OUTPUT)
.PHONY := getdeps cmake appimage-prepare
