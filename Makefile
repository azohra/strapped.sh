.PHONY: all perms test build strap

all: perms test build

perms:
	@chmod u+x *.sh
	@chmod u+x dev/*.sh
	@chmod u+x straps/**/*.sh

test:
	@shellcheck ./strapped.sh
	@shellcheck ./straps/**/*.sh

build:
	@./dev/build.sh

strap:
	@./dev/generate_strap.sh $(name)