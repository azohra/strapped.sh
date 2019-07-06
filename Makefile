INSTALL_DIR=/usr/local/bin

# List of files that contain the version
VERSIONED_FILES=strapped src/helpers.sh _static/_stay/index.html
VERSION="0.3.0"

VERSION_REPLACE_EXP="s/^VERSION=\".+\"/VERSION=\"${VERSION}\"/g"

.PHONY: all exec install uninstall test strap straps docs

all: exec straps binary docs test   

exec:
	@chmod u+x build/*.sh

test:
	@shellcheck ./strapped
	@shellcheck ./straps/**/**/*.sh
	@shellcheck ./build/*.sh

docs:
	@./build/docs.sh

strap: update-version
	@./build/compiler.sh ${yml}

straps: update-version
	@./build/straps.sh

binary: update-version
	@./build/binary.sh

release:
	@echo "Generating a release for strapped"
	@wget -N --quiet https://github.com/azohra/strapped.sh/archive/${VERSION}.tar.gz
	@echo "1. Fetched the corresponding release from GitHub: https://github.com/azohra/strapped.sh/archive/${VERSION}.tar.gz"
	@python build/generate_release.py -d ../homebrew-tools -t ${VERSION}
	@rm ${VERSION}.tar.gz

install: strapped
	@echo "📦 Installing strapped"
	@mkdir -p $(INSTALL_DIR)
	@cp strapped $(INSTALL_DIR)/strapped
	@chmod u+x $(INSTALL_DIR)/strapped

uninstall:
	@echo "🗑️  Uninstalling strapped"
	@rm $(INSTALL_DIR)/strapped

$(VERSIONED_FILES): Makefile
	@echo "Updateing version in " $@ " to "$(VERSION)
	@sed -i .old -E $(VERSION_REPLACE_EXP) $@ && rm "$@.old"

.PHONY: update-version
update-version: $(VERSIONED_FILES)
