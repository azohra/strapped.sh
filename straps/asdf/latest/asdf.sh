#!/bin/bash 

function strapped_asdf() {
	# Variables to hold the deps and corresponding checks
	local __deps="asdf "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "ERROR: dep ${dep} not found:"
			case "${dep}" in
			"asdf")
				echo -e "
	Please ensure you have asdf installed on your system 
	To install asdf, follow the instructions at https://asdf-vm.com/#/core-manage-asdf-vm 
"
			;;
			esac
			exit 1
		fi
	done

	# Declaring local variables for the 'plugins' routine
	local name
	local url

	# Declaring local variables for the 'versions' routine
	local dir
	local name
	local version
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'plugins'
	for ((i=0; i<$( ysh -T "${input}" -c plugins ); i++)); do

		# Getting fields for routine 'plugins'
		name=$( ysh -T "${input}" -l plugins -i ${i} -Q name )
		url=$( ysh -T "${input}" -l plugins -i ${i} -Q url )

		# Writing message for routine 'plugins'
		pretty_print ":info:" "🐙 adding ${name} plugin to asdf"

		# Executing the command(s) for routine 'plugins'
		run_command "asdf plugin-add ${name} ${url}"
	done


	# performing functionality for routine 'versions'
	for ((i=0; i<$( ysh -T "${input}" -c versions ); i++)); do

		# Getting fields for routine 'versions'
		dir=$( ysh -T "${input}" -l versions -i ${i} -Q dir )
		name=$( ysh -T "${input}" -l versions -i ${i} -Q name )
		version=$( ysh -T "${input}" -l versions -i ${i} -Q version )

		# Writing message for routine 'versions'
		pretty_print ":info:" "⌨ shimming ${name} to ${version}"

		# Executing the command(s) for routine 'versions'
		run_command "test '${dir}' && (cd ${dir} && asdf local ${name} ${version}) || asdf global global ${name} ${version}"
	done
}
