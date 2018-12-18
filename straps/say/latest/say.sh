#!/bin/bash 

function strapped_say() {
	# Variables to hold the deps and corresponding checks
	local __deps="say "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "dep ${dep} not found:"
			case "${dep}" in
			"say")
				echo -e "	Please ensure you have say installed on your system 
	say is a program that comes pre-installed on MacOS 
"
			;;
			esac
			exit 1
		fi
	done

	# Declaring local variables for the 'phrase' routine
	local voice
	local text

	# Declaring local variables for the 'file' routine
	local voice
	local file
	local input=${1}

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
