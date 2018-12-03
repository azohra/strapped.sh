#!/bin/bash 

function strapped_unix_utils() {
	# Variables to hold the deps and corresponding checks
	local __deps="echo mkdir touch "
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

	local HOME
	local dir
	local file
	local msg
	local i=0
	local input=${1}

	# performing functionality for mkdir
	for ((i=0; i<$( q_count "${input}" "mkdir"); i++)); do
		# Getting fields
		dir=$(q "${input}" "mkdir.\\[${i}\\].dir")
		# Writing message
		pretty_print ":info:" "📂 making ${dir}"
		# Executing the command(s)
		run_command "mkdir ${dir}"
	done

	# performing functionality for touch
	for ((i=0; i<$( q_count "${input}" "touch"); i++)); do
		# Getting fields
		file=$(q "${input}" "touch.\\[${i}\\].file")
		# Writing message
		pretty_print ":info:" "👉 making ${file}"
		# Executing the command(s)
		run_command "touch ${file}"
	done

	# performing functionality for echo
	for ((i=0; i<$( q_count "${input}" "echo"); i++)); do
		# Getting fields
		msg=$(q "${input}" "echo.\\[${i}\\].msg")
		# Executing the command(s)
		run_command "echo \"🗣 ${msg}\""
	done
}
