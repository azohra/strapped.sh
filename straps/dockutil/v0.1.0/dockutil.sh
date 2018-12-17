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
		# Deciding if the dependancy has been satisfied
		if [[ ! "${__woo}" = "1" ]]; then echo "dependancy ${dep} not met" && exit 2; fi
	done
	# Commands that run before the routines start
	run_command "dockutil --remove all --no-restart"

	# Declaring local variables for the 'apps' routine
	local path
	local pos

	# Declaring local variables for the 'dirs' routine
	local display
	local sort
	local path
	local view
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'apps'
	for ((i=0; i<$( ysh -T "${input}" -c apps ); i++)); do

		# Getting fields for routine 'apps'
		path=$( ysh -T "${input}" -l apps -i ${i} -Q path )
		pos=$( ysh -T "${input}" -l apps -i ${i} -Q pos )

		# Writing message for routine 'apps'
		pretty_print ":info:" "🚢 adding ${path}"

		# Executing the command(s) for routine 'apps'
		run_command "dockutil --add \"${path}\" --position ${pos} --no-restart"
	done


	# performing functionality for routine 'dirs'
	for ((i=0; i<$( ysh -T "${input}" -c dirs ); i++)); do

		# Getting fields for routine 'dirs'
		display=$( ysh -T "${input}" -l dirs -i ${i} -Q display )
		sort=$( ysh -T "${input}" -l dirs -i ${i} -Q sort )
		path=$( ysh -T "${input}" -l dirs -i ${i} -Q path )
		view=$( ysh -T "${input}" -l dirs -i ${i} -Q view )

		# Writing message for routine 'dirs'
		pretty_print ":info:" "🚢 adding ${path}"

		# Executing the command(s) for routine 'dirs'
		run_command "dockutil --add \"${path}\" --view ${view} --display ${display} --sort ${sort} --no-restart"
	done
	# Commands that run after the routines finish
	run_command "killall -KILL Dock"
}
