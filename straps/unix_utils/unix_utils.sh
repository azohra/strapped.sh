#!/bin/bash
strapped_unix_utils_before () { 
   return
}

strapped_unix_utils () {

    local ln_count
    local mkdir_count
    local echo_count
    local dir
    local link
    local folder
    local phrase

    ln_count=$(yq read "${1}" -j | jq -r '.unix_utils.ln | length')
    for i in $(seq 1 "${ln_count}"); do
        dir=$(yq read "${1}" -j | jq -r ".unix_utils.ln[${i}-1].dir")
        link=$(yq read "${1}" -j | jq -r ".unix_utils.ln[${i}-1].link")
        echo "🔗 linking ${dir} to ${link}"
        ln -snf "${dir}" "${link}"
    done

    mkdir_count=$(yq read "${1}" -j | jq -r '.unix_utils.mkdir | length')
    for i in $(seq 1 "${mkdir_count}"); do
        folder=$(yq read "${1}" -j | jq -r ".unix_utils.mkdir[${i}-1].dir")
        echo "📂 creating directory ${folder}"
        mkdir -p "${folder}"
    done

    echo_count=$(yq read "${1}" -j | jq -r '.unix_utils.echo | length')
    for i in $(seq 1 "${echo_count}"); do
        phrase=$(yq read "${1}" -j | jq -r ".unix_utils.echo[${i}-1].phrase")
        echo -e "🗣️  ${phrase}"
    done
}

strapped_unix_utils_after () { 
    return 
}


