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
    local user_json

    user_json=$1
    ln_count=$(jq -r '.ln | length' <<< "$user_json")
    mkdir_count=$(jq -r '.mkdir | length' <<< "$user_json")
    echo_count=$(jq -r '.echo | length' <<< "$user_json")
    source_count=$(jq -r '.source | length' <<< "$user_json")

    for (( i=0; i <ln_count; i++ )); do
        dir=$(jq -r ".ln[${i}].dir" <<< "$user_json")
        link=$(jq -r ".ln[${i}].link" <<< "$user_json")
        echo "🔗 linking ${dir} to ${link}"
        ln -snf "${dir}" "${link}"
    done

    for (( i=0; i <mkdir_count; i++ )); do
        folder=$(jq -r ".mkdir[${i}].dir" <<< "$user_json")
        echo "📂 creating ${folder}"
        mkdir -p "${folder}"
    done

    for (( i=0; i <echo_count; i++ )); do
        phrase=$(jq -r ".echo[${i}].phrase" <<< "$user_json")
        echo -e "🗣️  ${phrase}"
    done

    for (( i=0; i <source_count; i++ )); do
        file=$(jq -r ".source[${i}].file" <<< "$user_json")
        echo "📤 sourcing ${file}"
        source "${file}"
    done
}

strapped_unix_utils_after () { 
    return 
}


