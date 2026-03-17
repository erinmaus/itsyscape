DIALOG_INPUTS = $(shell find ./itsyscape/Resources/Game/Dialog -type f -name 'Dialog.ink')
DIALOG_OUTPUTS = $(patsubst ./itsyscape/Resources/Game/Dialog/%/Dialog.ink, ./itsyscape/Resources/Game/Dialog/%/Dialog.json, $(DIALOG_INPUTS))
DIALOG_DEPS = $(patsubst ./itsyscape/Resources/Game/Dialog/%/Dialog.ink, ./build/%.dialog.ink.dep, $(DIALOG_INPUTS))

BOOK_INPUTS = $(shell find ./itsyscape/Resources/Game/Books -type f -name 'Book.ink')
BOOK_OUTPUTS = $(patsubst ./itsyscape/Resources/Game/Books/%/Book.ink, ./itsyscape/Resources/Game/Books/%/Book.json, $(BOOK_INPUTS))
BOOK_DEPS = $(patsubst ./itsyscape/Resources/Game/Books/%/Book.ink, ./build/%.book.ink.dep, $(BOOK_INPUTS))

INKLECATE_VERSION := v.1.2.0
LUAJIT := luajit

MSYS_VERSION := $(if $(findstring Msys, $(shell uname -o)),$(word 1, $(subst ., ,$(shell uname -r))),0)
ifneq ($(MSYS_VERSION),0)
	INKLECATE_ARCHIVE := inklecate_windows.zip
	INKLECATE_BIN = inklecate.exe
else
	INKLECATE_BIN = inklecate
	ifeq ($(shell uname),Darwin)
		INKLECATE_ARCHIVE := inklecate_mac.zip
	else
		INKLECATE_ARCHIVE := inklecate_linux.zip
	endif
endif

-include $(DIALOG_DEPS)

./build:
	mkdir -p ./build

./build/${INKLECATE_ARCHIVE}: | ./build
	curl -L https://github.com/inkle/ink/releases/download/${INKLECATE_VERSION}/${INKLECATE_ARCHIVE} -o ./build/${INKLECATE_ARCHIVE}

./build/${INKLECATE_BIN}: ./build/${INKLECATE_ARCHIVE}
	cd build && unzip -o ${INKLECATE_ARCHIVE}
	touch ./build/${INKLECATE_BIN}

$(DIALOG_DEPS): ./build/%.dialog.ink.dep: ./itsyscape/Resources/Game/Dialog/%/Dialog.ink ./cicd/common/make_ink_deps.lua | ./build
	$(LUAJIT) ./cicd/common/make_ink_deps.lua "$<" "$@"

$(BOOK_DEPS): ./build/%.book.ink.dep: ./itsyscape/Resources/Game/Books/%/Book.ink ./cicd/common/make_ink_deps.lua | ./build
	$(LUAJIT) ./cicd/common/make_ink_deps.lua "$<" "$@"

./itsyscape/Resources/Game/Dialog/%/Dialog.json: ./itsyscape/Resources/Game/Dialog/%/Dialog.ink ./build/%.dialog.ink.dep ./build/${INKLECATE_BIN}
	./build/${INKLECATE_BIN} -o "$@" "$<"

./itsyscape/Resources/Game/Books/%/Book.json: ./itsyscape/Resources/Game/Books/%/Book.ink ./build/%.book.ink.dep ./build/${INKLECATE_BIN}
	./build/${INKLECATE_BIN} -o "$@" "$<"

.PHONY: all clean
all: $(DIALOG_OUTPUTS) $(BOOK_OUTPUTS)

clean:
	rm $(DIALOG_OUTPUTS)
	rm -r ./build