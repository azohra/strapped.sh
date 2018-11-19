.PHONY: all perms test docs strap

all: perms test

perms:
	@chmod u+x *.sh
	@chmod u+x straps/**/*.sh

test:
	@shellcheck strapped.sh
	@shopt -s globstar; shellcheck straps/**/*.sh

docs:
	@./build.sh

strap:
	@./generate_strap.sh $(name)