.PHONY: all exec test strap straps docs integrity

all: exec straps integrity docs test   

exec:
	@chmod u+x *.sh
	@chmod u+x build/*.sh
	@chmod u+x straps/**/*.sh

test:
	@shellcheck ./strapped.sh
	@shellcheck ./straps/**/*.sh
	@shellcheck ./straps/**/**/*.sh
	@shellcheck ./build/*.sh

docs:
	@./build/docs.sh

integrity:
	@./build/integrity.sh

strap:
	@./build/compiler.sh ${yml}

straps:
	@./build/straps.sh