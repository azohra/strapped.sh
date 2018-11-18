#!/bin/bash
strapped_before () { 
    if [ "${__passed_straps}" ]; then 
        __straps="${__passed_straps//,/ }"
    else
        __straps=$(yq read "${__config_file}" -j | jq -r 'keys[]' | tr '\n' ' ' ) 
    fi
    echo -e "${C_GREEN}Requested Straps :${C_BLUE} ${__straps}${C_REG}"

    if ! [ "${__auto}" ]; then 
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
    for strap in ${__straps}; do
        if [[ ${strap} = "strapped" ]]; then continue; fi
        if [[ ${__strap_repo} =~ ${__url_regex} ]]; then
            source /dev/stdin <<< "$(curl -s "${__strap_repo}/${strap}.sh")"
        else
            source "${__strap_repo}/${strap}.sh"
        fi
        echo -e "\\n${C_GREEN}Strap: ${C_BLUE}${strap}${C_REG}"
        strapped_"${strap}"_before "${__config_file}"
        strapped_"${strap}" "${__config_file}"
        strapped_"${strap}"_after "${__config_file}"
    done
}

strapped_after () { 
    return 
}

