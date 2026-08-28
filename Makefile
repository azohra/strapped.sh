INSTALL_DIR=/usr/local/bin

# List of files that contain the version
VERSIONED_FILES=strapped src/helpers.sh
VERSION="0.3.0"

VERSION_REPLACE_EXP="s/^VERSION=\".+\"/VERSION=\"${VERSION}\"/g"

.PHONY: all exec install uninstall test strap straps docs

all: exec straps binary docs test   

exec:
	@chmod u+x build/*.sh

test:
	@mise run check

docs:
	@./build/docs.sh

strap: update-version
	@./build/compiler.sh ${yml}

straps: update-version
	@./build/straps.sh

binary: update-version
	@./build/binary.sh

install: strapped
	@echo "📦 Installing strapped"
	@mkdir -p $(INSTALL_DIR)
	@cp strapped $(INSTALL_DIR)/strapped
	@chmod u+x $(INSTALL_DIR)/strapped

uninstall:
	@echo "🗑️  Uninstalling strapped"
	@rm $(INSTALL_DIR)/strapped

$(VERSIONED_FILES): Makefile
	@[ -f "$@" ] || { echo "version: refusing — $@ is missing" >&2; exit 1; }
	@echo "Updating version in " $@ " to "$(VERSION)
	@sed -i .old -E $(VERSION_REPLACE_EXP) $@ && rm "$@.old"

.PHONY: update-version
update-version: $(VERSIONED_FILES)
