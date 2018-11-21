#!/bin/bash
# shellcheck source=/dev/null

strapped_unix_utils_before () { 
   return
}

strapped_unix_utils () {
    local ln_count
    local mkdir_count
    local echo_count
    local source_count
    local dir
    local link
    local folder
    local phrase
    local file

    ln_count=$(jq -r '.unix_utils.ln | length' <<< "${1}")
    mkdir_count=$(jq -r '.unix_utils.mkdir | length' <<< "${1}")
    echo_count=$(jq -r '.unix_utils.echo | length' <<< "${1}")
    source_count=$(jq -r '.unix_utils.source | length' <<< "${1}")

    for (( i=0; i <ln_count; i++ )); do
        dir=$(jq -r ".unix_utils.ln[${i}].dir" <<< "${1}")
        link=$(jq -r ".unix_utils.ln[${i}].link" <<< "${1}")
        echo "🔗 linking ${dir} to ${link}"
        ln -snf "${dir}" "${link}"
    done

    for (( i=0; i <mkdir_count; i++ )); do
        folder=$(jq -r ".unix_utils.mkdir[${i}].dir" <<< "${1}")
        echo "📂 creating ${folder}"
        mkdir -p "${folder}"
    done

    for (( i=0; i <echo_count; i++ )); do
        phrase=$(jq -r ".unix_utils.echo[${i}].phrase" <<< "${1}")
        echo -e "🗣️  ${phrase}"
    done

    for (( i=0; i <source_count; i++ )); do
        file=$(jq -r ".unix_utils.source[${i}].file" <<< "${1}")
        echo "📤 sourcing ${file}"
        source "${file}"
    done
}

strapped_unix_utils_after () { 
    return 
}


