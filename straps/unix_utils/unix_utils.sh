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
    local user_config

    user_config=$1
    ln_count=$(q_count "$user_config" "ln")
    mkdir_count=$(q_count "$user_config" "mkdir")
    echo_count=$(q_count "$user_config" "echo")
    source_count=$(q_count "$user_config" "source")

    for (( i=0; i <ln_count; i++ )); do
        dir=$(q "$user_config" "ln.\\[${i}\\].dir")
        link=$(q "$user_config" "ln.\\[${i}\\].link")
        echo "🔗 linking ${dir} to ${link}"
        ln -snf "${dir}" "${link}"
    done

    for (( i=0; i <mkdir_count; i++ )); do
        folder=$(q "$user_config" "mkdir.\\[${i}\\].dir")
        echo "📂 creating ${folder}"
        mkdir -p "${folder}"
    done

    for (( i=0; i <echo_count; i++ )); do
        phrase=$(q "$user_config" "echo.\\[$i\\].phrase")
        echo "🗣️  ${phrase}"
    done

    for (( i=0; i <source_count; i++ )); do
        file=$(q "$user_config" "source.\\[${i}\\].file")
        echo "📤 sourcing ${file}"
        source "${file}"
    done
}

strapped_unix_utils_after () { 
    return 
}


