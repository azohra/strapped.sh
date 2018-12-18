#!/bin/bash 

function strapped_bash() {
	# Variables to hold the deps and corresponding checks
	local __deps="echo mkdir touch exec "
	local __resp
	# Performing each check for each dep
	for dep in ${__deps}; do
		command -v "${dep}" &> /dev/null
		__resp=$?
		if [[ $__resp -ne 0 ]]; then
			echo "dep ${dep} not found:"
			case "${dep}" in
			"echo")
				echo -e "	Please ensure you have echo installed on your system 
"
			;;
			"mkdir")
				echo -e "	Please ensure you have mkdir installed on your system 
"
			;;
			"touch")
				echo -e "	Please ensure you have touch installed on your system 
"
			;;
			"exec")
				echo -e "	Please ensure you have exec installed on your system 
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

	# Declaring local variables for the 'echo' routine
	local msg

	# Declaring local variables for the 'exec' routine
	local file
	local input=${1}

	# Initialize array iterator
	local i=0

	# performing functionality for routine 'mkdir'
	for ((i=0; i<$( ysh -T "${input}" -c mkdir ); i++)); do

		# Getting fields for routine 'mkdir'
		dir=$( ysh -T "${input}" -l mkdir -i ${i} -Q dir )

		# Writing message for routine 'mkdir'
		pretty_print ":info:" "📂 creating ${dir}"

		# Executing the command(s) for routine 'mkdir'
		run_command "mkdir -p ${dir}"
	done


	# performing functionality for routine 'touch'
	for ((i=0; i<$( ysh -T "${input}" -c touch ); i++)); do

		# Getting fields for routine 'touch'
		file=$( ysh -T "${input}" -l touch -i ${i} -Q file )

		# Writing message for routine 'touch'
		pretty_print ":info:" "👉 creating ${file}"

		# Executing the command(s) for routine 'touch'
		run_command "touch ${file}"
	done


	# performing functionality for routine 'echo'
	for ((i=0; i<$( ysh -T "${input}" -c echo ); i++)); do

		# Getting fields for routine 'echo'
		msg=$( ysh -T "${input}" -l echo -i ${i} -Q msg )

		# Writing message for routine 'echo'
		pretty_print ":info:" "🗣  ${msg}"

		# Executing the command(s) for routine 'echo'
		run_command ""
	done


	# performing functionality for routine 'exec'
	for ((i=0; i<$( ysh -T "${input}" -c exec ); i++)); do

		# Getting fields for routine 'exec'
		file=$( ysh -T "${input}" -l exec -i ${i} -Q file )

		# Writing message for routine 'exec'
		pretty_print ":info:" "👟 running ${file}"

		# Executing the command(s) for routine 'exec'
		run_command "exec ${file}"
	done
}
