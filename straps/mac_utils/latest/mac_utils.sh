#!/bin/bash 

function strapped_mac_utils() {
	# Variables to hold the deps and corresponding checks
	local __deps=" "
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

	# Declaring local variables for the 'phrase' routine
	local voice
	local text

	# Declaring local variables for the 'file' routine
	local voice
	local file
	local input=${1}

	# Declaring top-level local strap variables
	local HOME

	# Setting top-level local strap variables
	HOME=$( ysh -T "${input}" -Q HOME)

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'phrase'
	for ((i=0; i<$( ysh -T "${input}" -c phrase ); i++)); do

		# Getting fields for routine 'phrase'
		voice=$( ysh -T "${input}" -l phrase -i ${i} -Q voice )
		text=$( ysh -T "${input}" -l phrase -i ${i} -Q text )

		# Executing the command(s) for routine 'phrase'
		run_command "say -v ${voice} ${text}"
	done


	# performing functionality for routine 'file'
	for ((i=0; i<$( ysh -T "${input}" -c file ); i++)); do

		# Getting fields for routine 'file'
		voice=$( ysh -T "${input}" -l file -i ${i} -Q voice )
		file=$( ysh -T "${input}" -l file -i ${i} -Q file )

		# Executing the command(s) for routine 'file'
		run_command "say -v ${voice} -f ${file}"
	done
}
