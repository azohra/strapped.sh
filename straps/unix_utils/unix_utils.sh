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

    ln_count=$(yq read "${1}" -j | jq -r '.unix_utils.ln | length')
    mkdir_count=$(yq read "${1}" -j | jq -r '.unix_utils.mkdir | length')
    echo_count=$(yq read "${1}" -j | jq -r '.unix_utils.echo | length')
    source_count=$(yq read "${1}" -j | jq -r '.unix_utils.source | length')

    for (( i=0; i <ln_count; i++ )); do
        dir=$(yq read "${1}" -j | jq -r ".unix_utils.ln[${i}].dir")
        link=$(yq read "${1}" -j | jq -r ".unix_utils.ln[${i}].link")
        echo "🔗 linking ${dir} to ${link}"
        ln -snf "${dir}" "${link}"
    done

    for (( i=0; i <mkdir_count; i++ )); do
        folder=$(yq read "${1}" -j | jq -r ".unix_utils.mkdir[${i}].dir")
        echo "📂 creating ${folder}"
        mkdir -p "${folder}"
    done

    for (( i=0; i <echo_count; i++ )); do
        phrase=$(yq read "${1}" -j | jq -r ".unix_utils.echo[${i}].phrase")
        echo -e "🗣️  ${phrase}"
    done

    for (( i=0; i <source_count; i++ )); do
        file=$(yq read "${1}" -j | jq -r ".unix_utils.source[${i}].file")
        echo "📤 sourcing ${file}"
        source "${file}"
    done
}

strapped_unix_utils_after () { 
    return 
}


