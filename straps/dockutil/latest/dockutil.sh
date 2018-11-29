#!/bin/bash 

function strapped_dockutil() {
	# Variables to hold the deps and corresponding checks
	local __deps="dockutil "
	local __checks="-v -V --version"
	local __woo=""

	# Performing each check for each dep
	for dep in ${__deps}; do
		for check in ${__checks}; do
			if "${dep}" "${check}" &> /dev/null; then __woo=1; fi
		done
	done

	# Deciding if the dependancy has been satisfied
	if [[ ! "${__woo}" = "1" ]]; then echo "deps not met" && exit 2; fi 

	# Commands that run before the routines start
	dockutil --remove all --no-restart


	local path
	local pos
	local display
	local sort
	local path
	local view
	local i=0
	local input=${1}

	# performing functionality for apps
	for ((i=0; i<$( q_count "${input}" "apps"); i++)); do
		# Getting fields
		path=$(q "${input}" "apps.\\[${i}\\].path")
		pos=$(q "${input}" "apps.\\[${i}\\].pos")
		# Writing message
		pretty_print ":info:" "🚢 adding ${path}"
		# Executing the command(s)
		run_command "dockutil --add ${path} --position ${pos} --no-restart"
	done

	# performing functionality for dirs
	for ((i=0; i<$( q_count "${input}" "dirs"); i++)); do
		# Getting fields
		display=$(q "${input}" "dirs.\\[${i}\\].display")
		sort=$(q "${input}" "dirs.\\[${i}\\].sort")
		path=$(q "${input}" "dirs.\\[${i}\\].path")
		view=$(q "${input}" "dirs.\\[${i}\\].view")
		# Writing message
		pretty_print ":info:" "🚢 adding ${path}"
		# Executing the command(s)
		run_command "dockutil --add ${path} --view ${view} --display ${display} --sort ${sort} --no-restart"
	done
	# Commands that run after the routines finish
	killall -KILL Dock
}
