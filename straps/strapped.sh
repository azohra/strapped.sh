#!/bin/bash
# shellcheck source=/dev/null

strapped_before () {

    local l_yml_file
    local l_custom_straps
    local l_auto_approve

    l_yml_file=$1
    l_custom_straps=$2
    l_auto_approve=$3
    
    if [[ "${l_custom_straps}" = "0" ]]; then 
        __straps=$(yq read "${l_yml_file}" -j | jq -r 'keys[]' | tr '\n' ' ' ) 
    else
        __straps="${l_custom_straps//,/ }"
    fi
    echo -e "${C_GREEN}Requested Straps :${C_BLUE} ${__straps}${C_REG}"

    if ! [ "${l_auto_approve}" ]; then 
        printf "Execute? Y/N: "
        while true
        do
          read -r ans
          case ${ans} in
           [yY]* ) printf "\\n🔥🔥🔥 LETS DO THIS 🔥🔥🔥\\n" && break;;
           [nN]* ) printf "\\n🔥🔥🔥 CRISIS AVERTED 🔥🔥🔥\\n" && exit;;
           * )     printf "Y/N: ";;
          esac
        done
    fi
}

strapped () {

    local l_strap_repo
    local l_yml_file

    l_strap_repo=$1
    l_yml_file=$2

    for strap in ${__straps}; do
        if [[ ${strap} = "strapped" ]]; then continue; fi
        if [[ ${l_strap_repo} =~ ${__url_regex} ]]; then
            source /dev/stdin <<< "$(curl -s "${l_strap_repo}/${strap}.sh")"
        else
            source "${l_strap_repo}/${strap}.sh"
        fi
        echo -e "\\n${C_GREEN}Strap: ${C_BLUE}${strap}${C_REG}"
        strapped_"${strap}"_before "${l_yml_file}"
        strapped_"${strap}" "${l_yml_file}"
        strapped_"${strap}"_after "${l_yml_file}"
    done
}

strapped_after () { 
    return 
}

