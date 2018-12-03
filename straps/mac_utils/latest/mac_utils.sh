#!/bin/bash 

function strapped_mac_utils() {
	local HOME
	local voice
	local text
	local voice
	local file
	local i=0
	local input=${1}

	# performing functionality for phrase
	for ((i=0; i<$( q_count "${input}" "phrase"); i++)); do
		# Getting fields
		voice=$(q "${input}" "phrase.\\[${i}\\].voice")
		text=$(q "${input}" "phrase.\\[${i}\\].text")
		# Executing the command(s)
		run_command "say -v ${voice} ${text}"
	done

	# performing functionality for file
	for ((i=0; i<$( q_count "${input}" "file"); i++)); do
		# Getting fields
		voice=$(q "${input}" "file.\\[${i}\\].voice")
		file=$(q "${input}" "file.\\[${i}\\].file")
		# Executing the command(s)
		run_command "say -v ${voice} -f ${file}"
	done
}
