#!/bin/bash 

function strapped_dockutil() {
	# Variables to hold the deps and corresponding checks
	local __deps="dockutil "
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

	# Commands that run before the routines start
	dockutil --remove all --no-restart


	local path
	local display
	local sort
	local path
	local view
	local name
	local position
	local i=0
	local input=${1}

	# performing functionality for apps
	for ((i=0; i<$( q_count "${input}" "apps"); i++)); do
		# Getting fields
		path=$(q "${input}" "apps.\\[${i}\\].path")
		# Writing message
		echo -e "🚢 adding ${path}"
		# Executing the command(s)
		dockutil --add "${path}" --no-restart
	done

	# performing functionality for dirs
	for ((i=0; i<$( q_count "${input}" "dirs"); i++)); do
		# Getting fields
		display=$(q "${input}" "dirs.\\[${i}\\].display")
		sort=$(q "${input}" "dirs.\\[${i}\\].sort")
		path=$(q "${input}" "dirs.\\[${i}\\].path")
		view=$(q "${input}" "dirs.\\[${i}\\].view")
		# Writing message
		echo -e "🚢 adding ${path}"
		# Executing the command(s)
		dockutil --add "${path}" --view "${view}" --display "${display}" --sort "${sort}" --no-restart
	done

	# performing functionality for position
	for ((i=0; i<$( q_count "${input}" "position"); i++)); do
		# Getting fields
		name=$(q "${input}" "position.\\[${i}\\].name")
		position=$(q "${input}" "position.\\[${i}\\].position")
		# Writing message
		echo -e "🚢 moving ${name} to position ${position}"
		# Executing the command(s)
		dockutil --move "${name}" --position "${position}" --no-restart
	done
}
