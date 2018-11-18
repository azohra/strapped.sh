#!/bin/bash
# shellcheck source=/dev/null

set -e
C_GREEN="\\033[32m"
C_BLUE="\\033[34m"
C_REG="\\033[0;39m"
__url_regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'
__config_loc="${HOME}/.strapped/strapped.yml"

while [ $# -gt 0 ] ; do
    case "$1" in
    -c|--config)
        __config_loc="$2"
        shift # extra value 
    ;;
    -s|--straps)
        __passed_straps="$2"
        shift # extra value 
    ;;
    -a|--agree)
        __auto_apply=yes
    ;;
    -h|--help)
        echo '🔫Print Help Here'
    ;;
    -*)
        "Unknown option: '$1'"
    ;;
    esac
    shift
done

load_config () {
    if [ -f '/tmp/strapped.yml' ]; then rm /tmp/strapped.yml; fi 
    if [[ ${__config_loc} =~ ${__url_regex} ]]; then 
        curl -s "${__config_loc}" --output /tmp/strapped.yml
        __config_file='/tmp/strapped.yml'
    else
        __config_file=${__config_loc}
    fi
    if [ ! -f "${__config_file}" ]; then echo "Config Could Not Be Loaded!" && exit 2; fi
    echo -e "\\n${C_GREEN}Using Config From: ${C_BLUE}${__config_loc}${C_REG}" 
}

load_straps () {
    __strap_repo=$(yq read "${__config_file}" -j | jq -r '.strapped.repo')
    if [[ "${__strap_repo}" = "null" ]]; then echo "You must provide a strap repo" && exit 2; fi
    if [ "${__passed_straps}" ]; then 
        __straps="${__passed_straps//,/ }"
    else
        __straps=$(yq read "${__config_file}" -j | jq -r 'keys[]')
    fi 
    for strap in ${__straps}; do
        if [[ ${strap} = "strap_repo" ]]; then continue; fi
        if [[ ${__strap_repo} =~ ${__url_regex} ]]; then 
            source /dev/stdin <<< "$(curl -s "${__strap_repo}/${strap}.sh")"
        else
            source "${__strap_repo}/${strap}.sh"
        fi
    done
    echo -e "${C_GREEN}Using Straps From: ${C_BLUE}${__strap_repo}${C_REG}"
}

execute_straps () {
    for strap in ${__straps}; do
        if [[ "${strap}" = "strap_repo" ]]; then continue; fi
        echo -e "\\n${C_GREEN}Strap: ${C_BLUE}${strap}${C_REG}"
        strapped_"${strap}"_before "${__config_file}"
        strapped_"${strap}" "${__config_file}"
        strapped_"${strap}"_after "${__config_file}"
    done
}

ask_permission () {
    while true
    do
      echo -e "${C_GREEN}Run the strap? (Y/N)${C_REG} "
      read -r ans
      case ${ans} in
       [yY]* ) printf "\\n🔥🔥🔥 LETS DO THIS 🔥🔥🔥\\n" && break;;
       [nN]* ) printf "\\n🔥🔥🔥 CRISIS AVERTED 🔥🔥🔥\\n" && exit;;
       * )     echo "enter Y/y or N/n 😠";;
      esac
    done
}

check_deps () {
    if ! yq -V > /dev/null; then echo "😞 yq is required to run strapped.sh" && exit; fi 
    if ! jq -V > /dev/null; then echo "😞 jq required to run strapped.sh" && exit; fi 
}

check_deps
load_config
load_straps
if ! [ "${__auto_apply}" ]; then ask_permission; fi 
execute_straps