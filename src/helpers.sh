#!/bin/bash
# shellcheck source=/dev/null

C_GREEN="\\033[32m"
C_BLUE="\\033[94m"
C_REG="\\033[0;39m"
STRAPPED_DEBUG=""
custom_straps=""
auto_approve=""
base_repo="https://repo.strapped.sh"
yml_location="https://raw.githubusercontent.com/azohra/strapped/master/yml/first_run.yml"
url_regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'

# shellcheck disable=SC2034 
YSH_LIB=1;
# shellcheck disable=SC1091
source /dev/stdin <<< "$(curl -s https://raw.githubusercontent.com/azohra/yaml.sh/v0.2.0/ysh)"

pretty_print () { 
    local msg_type=${1} 
    local message=${2}
    
    case $msg_type in 
    ":log:" )  
        echo -e "\\n🔫 ${C_BLUE} ${message} ${C_REG}"
        ;;
    ":announce:" )  
        echo -e "${C_GREEN}${message%::*}:${C_BLUE} ${message#*::} ${C_REG}"
        ;;
    ":info:" )
        echo -e "${C_REG}${message}"
        ;;
    esac
        
}   

run_command() {
    # write your test however you want; this just tests if SILENT is non-empty
    if [ "$STRAPPED_DEBUG" ]; then
        eval "${1}"
    else
        eval "${1}" > /dev/null
    fi
}

parse_config() {
    # Check for YML
    if [[ "${yml_location}" =~ ${url_regex} ]]; then config=$(curl -s -L "${yml_location}" | ysh ); else config=$(ysh -f "${yml_location}"); fi
    if [ ! "${config}" ]; then pretty_print ":announce:" "Strapped::Config not found" && exit 2;else pretty_print ":announce:" "Config::${yml_location}"; fi
}

parse_strapped_repo() {
    # Check for Repo
    if [ "$(ysh -T "${config}" -Q "strapped.repo")" != "null" ]; then base_repo="$(ysh -T "${config}" -Q "strapped.repo")"; fi
    if [ ! "${base_repo}" ]; then pretty_print ":announce:" "Strapped::Repo not found" && exit 2;else pretty_print ":announce:" "Base Repo::${base_repo}"; fi
}

create_strap_array() {
    # Create Strap Array
    if [[ "${custom_straps}" ]]; then straps="${custom_straps//,/ }"; else straps=$(ysh -T "${config}" -t | uniq); fi
    straps=${straps/strapped /}
    if [ ! "${straps}" ]; then pretty_print ":announce:" "Strapped::Straps not found" && exit 2;else pretty_print ":announce:" "Straps::${straps//$'\n'/, }"; fi
}

ask_permission () {  
    local message=${1}
    pretty_print ":log:" "${message}"
    printf "(Y/N): "
    while true
    do
      if [ "${auto_approve}" ]; then ans="y" && printf "Y (auto)"; else read -r ans; fi
      case ${ans} in
       [yY]* ) break;;
       [nN]* ) exit;;
       * )     printf "Y/N: ";;
      esac
    done
}

stay_strapped () {
    local version
    local strap_repo

    for strap in ${straps}; do
        strap_config=$(ysh -T "${config}" -s "${strap}")

        # Get strapped repo
        strap_repo=$(ysh -T "${strap_config}" -Q "repo")
        strap_repo=${strap_repo:=${base_repo}}

        # Get strapped version
        version=$(ysh -T "${strap_config}" -Q "version")
        version=${version:="latest"}

        if [[ ${strap_repo} =~ ${url_regex} ]]; then
            source /dev/stdin <<< "$(curl -s -L "${strap_repo}/${strap}/${version}/${strap}.sh")"
        else
            source "${strap_repo}/${strap}/${version}/${strap}.sh"
        fi

        pretty_print ":announce:" "\\n${strap}::${version} from ${strap_repo}"

        strapped_"${strap}" "${strap_config}"
    done
}
