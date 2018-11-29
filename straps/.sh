function strapped_() {
	local __deps=""
	local __checks="-v -V --version"
	local __woo=""

	for dep in ${__deps}; do
		for check in ${__checks}; do
			if ${dep} ${check} &> /dev/null; then __woo=1; fi
		done
	done
	if [[ ! "${__woo}" = "1"]]; then echo -e "deps not met" && exit 2; fi
	local i=0
	local input=${1}

}
