#!/bin/bash 

function strapped_unix_utils() {
	# Variables to hold the deps and corresponding checks
	local __deps="echo brew "
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

	# Declaring top-level local strap variables
	local HOME
	local aah

	# Setting top-level local strap variables
	HOME=$( ysh -T "${input}" -Q HOME)
	aah=$( ysh -T "${input}" -Q aah)

	# Declaring local variables for the 'mkdir' routine
	local dir

	# Declaring local variables for the 'touch' routine
	local file
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'mkdir'
	for ((i=0; i<$( ysh -T "${input}" -c mkdir ); i++)); do

		# Getting fields for routine 'mkdir'
		dir=$( ysh -T "${input}" -l mkdir -i ${i} -Q dir )

		# Writing message for routine 'mkdir'
		pretty_print ":info:" "📂 making ${dir}"

		# Executing the command(s) for routine 'mkdir'
		run_command "mkdir ${dir}"
	done


	# performing functionality for routine 'touch'
	for ((i=0; i<$( ysh -T "${input}" -c touch ); i++)); do

		# Getting fields for routine 'touch'
		file=$( ysh -T "${input}" -l touch -i ${i} -Q file )

		# Writing message for routine 'touch'
		pretty_print ":info:" "👉 making ${file}"

		# Executing the command(s) for routine 'touch'
		run_command "touch ${file}"
	done
}
