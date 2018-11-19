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
    for (( i=ln_count; i>0; i-- )); do
        dir=$(yq read "${1}" -j | jq -r ".unix_utils.ln[${i}-1].dir")
        link=$(yq read "${1}" -j | jq -r ".unix_utils.ln[${i}-1].link")
        echo "🔗 linking ${dir} to ${link}"
        ln -snf "${dir}" "${link}"
    done

    mkdir_count=$(yq read "${1}" -j | jq -r '.unix_utils.mkdir | length')
    for (( i=mkdir_count; i>0; i-- )); do
        folder=$(yq read "${1}" -j | jq -r ".unix_utils.mkdir[${i}].dir")
        echo "📂 creating ${folder}"
        mkdir -p "${folder}"
    done

    echo_count=$(yq read "${1}" -j | jq -r '.unix_utils.echo | length')
    for (( i=echo_count; i>0; i-- )); do
        phrase=$(yq read "${1}" -j | jq -r ".unix_utils.echo[${i}-1].phrase")
        echo -e "🗣️  ${phrase}"
    done

    source_count=$(yq read "${1}" -j | jq -r '.unix_utils.source | length')
        for (( i=source_count; i>0; i-- )); do
        file=$(yq read "${1}" -j | jq -r ".unix_utils.source[${i}-1].file")
        echo "📤 sourcing ${file}"
        source "${file}"
    done
}

strapped_unix_utils_after () { 
    return 
}


