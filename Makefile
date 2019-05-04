INSTALL_DIR=/usr/local/bin

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

strap:
	@./build/compiler.sh ${yml}

straps:
	@./build/straps.sh

binary:
	@./build/binary.sh

install: strapped
	@echo "📦 Installing strapped"
	@mkdir -p $(INSTALL_DIR)
	@cp strapped $(INSTALL_DIR)/strapped
	@chmod u+x $(INSTALL_DIR)/strapped

uninstall:
	@echo "🗑️  Uninstalling strapped"
	@rm $(INSTALL_DIR)/strapped