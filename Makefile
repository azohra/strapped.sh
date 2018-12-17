.PHONY: all exec test strap straps docs integrity

all: exec straps docs test   

exec:
	@chmod u+x *.sh
	@chmod u+x build/*.sh

test:
	@shellcheck ./strapped.sh
	@shellcheck ./straps/**/**/*.sh
	@shellcheck ./build/*.sh

docs:
	@./build/docs.sh

strap:
	@./build/compiler.sh ${yml}

straps:
	@./build/straps.sh