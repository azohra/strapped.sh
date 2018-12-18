#!/bin/bash 

function strapped_wget() {
	# Variables to hold the deps and corresponding checks
	local __deps="wget "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "dep ${dep} not found:"
			case "${dep}" in
			"wget")
				echo -e "	Please ensure you have wget installed on your system 
"
			;;
			esac
			exit 1
		fi
	done

	# Declaring local variables for the 'download' routine
	local filename
	local url
	local folder
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'download'
	for ((i=0; i<$( ysh -T "${input}" -c download ); i++)); do

		# Getting fields for routine 'download'
		filename=$( ysh -T "${input}" -l download -i ${i} -Q filename )
		url=$( ysh -T "${input}" -l download -i ${i} -Q url )
		folder=$( ysh -T "${input}" -l download -i ${i} -Q folder )

		# Writing message for routine 'download'
		pretty_print ":info:" "💾 downloading ${url} into ${folder}/${filename}"

		# Executing the command(s) for routine 'download'
		run_command "wget -P ${folder} -O {filename} ${url}"
	done
}
