#!/bin/bash 

function strapped_unix_utils() {
	# Variables to hold the deps and corresponding checks
	local __deps="brew bash "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "dep ${dep} not found:"
			case "${dep}" in
			"brew")
				echo -e "	please install brew 
	you can find it here 
"
			;;
			"bash")
				echo -e "please install bash 
you can install it like this 
"
			;;
			esac
			exit 1
		fi
	done

	# Declaring local variables for the 'mkdir' routine
	local dir

	# Declaring local variables for the 'touch' routine
	local file
	local input=${1}

	# Declaring top-level local strap variables
	local HOME
	local aah

	# Setting top-level local strap variables
	HOME=$( ysh -T "${input}" -Q HOME)
	aah=$( ysh -T "${input}" -Q aah)

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
