#!/bin/bash 

function strapped_git() {
	# Variables to hold the deps and corresponding checks
	local __deps="git "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "ERROR: dep ${dep} not found:"
			case "${dep}" in
			"git")
				echo -e "
	Please ensure you have git installed on your system 
	We reccomend using strapped to install git 
	MacOS 
		 brew:  
			 packages:  
				 - { name: git }  
"
			;;
			esac
			exit 1
		fi
	done

	# Declaring local variables for the 'clone' routine
	local repo
	local folder
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'clone'
	for ((i=0; i<$( ysh -T "${input}" -c clone ); i++)); do

		# Getting fields for routine 'clone'
		repo=$( ysh -T "${input}" -l clone -i ${i} -Q repo )
		folder=$( ysh -T "${input}" -l clone -i ${i} -Q folder )

		# Writing message for routine 'clone'
		pretty_print ":info:" "💾 cloning ${repo} into ${folder}"

		# Executing the command(s) for routine 'clone'
		run_command "if [ ! -d ${folder} ] ; then mkdir ${folder} && git clone ${repo} ${folder}; fi"
	done
}
