#!/bin/bash 

function strapped_git() {
	# Variables to hold the deps and corresponding checks
	local __deps="git "
	local __checks="-v -V --version"
	local __woo=""

	# Performing each check for each dep
	for dep in ${__deps}; do
		for check in ${__checks}; do
			if "${dep} ${check}" &> /dev/null; then __woo=1; fi
		done
	done

	# Deciding if the dependancy has been satisfied
	if [[ ! "${__woo}" = "1" ]]; then echo "deps not met" && exit 2; fi 

	local repo
	local folder
	local i=0
	local input=${1}

	# performing functionality for clone
	for ((i=0; i<$( q_count "${input}" "clone"); i++)); do
		# Getting fields
		repo=$(q "${input}" "clone.\\[${i}\\].repo")
		folder=$(q "${input}" "clone.\\[${i}\\].folder")
		# Writing message
		echo -e "💾 cloning ${repo} into ${folder}"
		# Executing the command(s)
		git clone "${repo}" "${folder}"
	done
}
