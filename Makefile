.PHONY: all exec test strap straps docs

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
