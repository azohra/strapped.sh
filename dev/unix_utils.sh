	local source_count
	local dir
	local mkdir_count
	local dir
	local ln_count
	local link
	local dir
	local echo_count
	local phrase
	
	source_count=$(yq read ${1} -j | jq -r ".unix_utils.source | length")
	mkdir_count=$(yq read ${1} -j | jq -r ".unix_utils.mkdir | length")
	ln_count=$(yq read ${1} -j | jq -r ".unix_utils.ln | length")
	echo_count=$(yq read ${1} -j | jq -r ".unix_utils.echo | length")
	
	for (( l=source_count; l>0; l-- )); do
		dir=$(yq read "${1}" -j | jq -r ".unix_utils.source[${i}-1].dir")
		echo "#do shit with ${dir}"
	done
	
	for (( k=mkdir_count; k>0; k-- )); do
		dir=$(yq read "${1}" -j | jq -r ".unix_utils.mkdir[${i}-1].dir")
		echo "#do shit with ${dir}"
	done
	
	for (( j=ln_count; j>0; j-- )); do
		link=$(yq read "${1}" -j | jq -r ".unix_utils.ln[${i}-1].link")
		echo "#do shit with ${link}"
		dir=$(yq read "${1}" -j | jq -r ".unix_utils.ln[${i}-1].dir")
		echo "#do shit with ${dir}"
	done
	
	for (( i=echo_count; i>0; i-- )); do
		phrase=$(yq read "${1}" -j | jq -r ".unix_utils.echo[${i}-1].phrase")
		echo "#do shit with ${phrase}"
	done
	
	local source_count
	local dir
	local mkdir_count
	local dir
	local ln_count
	local link
	local dir
	local echo_count
	local phrase
	
	source_count=$(yq read ${1} -j | jq -r ".unix_utils.source | length")
	mkdir_count=$(yq read ${1} -j | jq -r ".unix_utils.mkdir | length")
	ln_count=$(yq read ${1} -j | jq -r ".unix_utils.ln | length")
	echo_count=$(yq read ${1} -j | jq -r ".unix_utils.echo | length")
	
	for (( l=source_count; l>0; l-- )); do
		dir=$(yq read "${1}" -j | jq -r ".unix_utils.source[${i}-1].dir")
		echo "#do shit with ${dir}"
	done
	
	for (( k=mkdir_count; k>0; k-- )); do
		dir=$(yq read "${1}" -j | jq -r ".unix_utils.mkdir[${i}-1].dir")
		echo "#do shit with ${dir}"
	done
	
	for (( j=ln_count; j>0; j-- )); do
		link=$(yq read "${1}" -j | jq -r ".unix_utils.ln[${i}-1].link")
		echo "#do shit with ${link}"
		dir=$(yq read "${1}" -j | jq -r ".unix_utils.ln[${i}-1].dir")
		echo "#do shit with ${dir}"
	done
	
	for (( i=echo_count; i>0; i-- )); do
		phrase=$(yq read "${1}" -j | jq -r ".unix_utils.echo[${i}-1].phrase")
		echo "#do shit with ${phrase}"
	done
	
	local source_count
	local dir
	local mkdir_count
	local dir
	local ln_count
	local link
	local dir
	local echo_count
	local phrase
	
	source_count=$(yq read ${1} -j | jq -r ".unix_utils.source | length")
	mkdir_count=$(yq read ${1} -j | jq -r ".unix_utils.mkdir | length")
	ln_count=$(yq read ${1} -j | jq -r ".unix_utils.ln | length")
	echo_count=$(yq read ${1} -j | jq -r ".unix_utils.echo | length")
	
	for (( l=source_count; l>0; l-- )); do
		dir=$(yq read "${1}" -j | jq -r ".unix_utils.source[${i}-1].dir")
		echo "#do shit with ${dir}"
	done
	
	for (( k=mkdir_count; k>0; k-- )); do
		dir=$(yq read "${1}" -j | jq -r ".unix_utils.mkdir[${i}-1].dir")
		echo "#do shit with ${dir}"
	done
	
	for (( j=ln_count; j>0; j-- )); do
		link=$(yq read "${1}" -j | jq -r ".unix_utils.ln[${i}-1].link")
		echo "#do shit with ${link}"
		dir=$(yq read "${1}" -j | jq -r ".unix_utils.ln[${i}-1].dir")
		echo "#do shit with ${dir}"
	done
	
	for (( i=echo_count; i>0; i-- )); do
		phrase=$(yq read "${1}" -j | jq -r ".unix_utils.echo[${i}-1].phrase")
		echo "#do shit with ${phrase}"
	done
	
