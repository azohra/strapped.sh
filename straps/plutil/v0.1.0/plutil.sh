#!/bin/bash 

function strapped_plutil() {
	# Variables to hold the deps and corresponding checks
	local __deps="plutil "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "ERROR: dep ${dep} not found:"
			case "${dep}" in
			"plutil")
				echo -e "
	Please ensure you have plutil installed on your system 
"
			;;
			esac
			exit 1
		fi
	done

	# Declaring local variables for the 'plists' routine
	local var_type
	local value
	local domain
	local key
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'plists'
	for ((i=0; i<$( ysh -T "${input}" -c plists ); i++)); do

		# Getting fields for routine 'plists'
		var_type=$( ysh -T "${input}" -l plists -i ${i} -Q var_type )
		value=$( ysh -T "${input}" -l plists -i ${i} -Q value )
		domain=$( ysh -T "${input}" -l plists -i ${i} -Q domain )
		key=$( ysh -T "${input}" -l plists -i ${i} -Q key )

		# Writing message for routine 'plists'
		pretty_print ":info:" "️🛠️ Updating ${domain} ${key} to ${value}"

		# Executing the command(s) for routine 'plists'
		run_command "plutil -replace ${key} -${var_type} ${value} ~/Library/Preferences/${domain}.plist"
	done
}
