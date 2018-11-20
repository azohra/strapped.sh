#!/bin/bash
# shellcheck source=/dev/null
set -e

C_GREEN="\\033[32m"
C_BLUE="\\033[34m"
C_REG="\\033[0;39m"

custom_straps=""
auto_approve=""
yml_location="https://raw.githubusercontent.com/azohra/strapped/master/yml/first_run.yml"
url_regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'

function usage {
    echo -e "\\nUsage: strapped [flags]\\n"
    echo "flags:"
    echo "  -u, --upgrade               upgrade strapped to the latest version"
    echo "  -v, --version               print the current strapped version"
    echo "  -a, --auto                  do not prompt for confirmation"
    echo "  -y, --yml file/url          path to a valid strapped yml config"
    echo "  -s, --straps string         run a subset of your config. Comma seperated."
    echo "  -h, --help                  prints this message"
    exit 1
}

function upgrade {
    rm /usr/local/bin/strapped
    curl -s https://stay.strapped.sh | sh
    echo "🔫 Upgraded Successfully!"
    exit 0
}

while [ $# -gt 0 ] ; do
    case "$1" in
    -u|--upgrade)
        upgrade
    ;;
    -y|--yml)
        yml_location="$2"
        shift # extra value 
    ;;
    -s|--straps)
        custom_straps="$2"
        shift # extra value 
    ;;
    -a|--auto)
        auto_approve="true"
    ;;
    -v|--version)
        echo 'v0.1' && exit 0
    ;;
    -h|--help)
        usage
    ;;
    -*)
        "Unknown option: '$1'"
    ;;
    esac
    shift
done

check_deps () {
    deps="yq jq brew"
    for dep in $deps; do
        if ! $dep --version > /dev/null; then echo "😞 ${dep} is required to run strapped.sh" && exit; fi 
    done
}

verify_config () {
    # Check for YML
    if [[ ${yml_location} =~ ${url_regex} ]]; then 
        curl -s "${yml_location}" --output /tmp/strapped.yml
        yml_file='/tmp/strapped.yml'
    else
        yml_file=${yml_location}
    fi
    if [ ! -f "${yml_file}" ]; then echo "Config Could Not Be Loaded!" && exit 2; fi
    echo -e "\\n${C_GREEN}Using Config From: ${C_BLUE}${yml_location}${C_REG}" 

    # Check for Repo
    strap_repo=$(yq read "${yml_file}" -j | jq -r '.strapped.repo')
    if [[ "${strap_repo}" = "null" ]]; then echo "You must provide a strap repo" && exit 2; fi
    echo -e "${C_GREEN}Using Straps From: ${C_BLUE}${strap_repo}${C_REG}"

    # Create Strap List
    if [[ "${custom_straps}" ]]; then
        straps="${custom_straps//,/ }"
    else
        straps=$(yq read "${yml_file}" -j | jq -r 'keys[]' | tr '\n' ' ' ) 
    fi
    echo -e "${C_GREEN}Requested Straps :${C_BLUE} ${straps}${C_REG}"
}

ask_permission () {    
    if ! [ "${auto_approve}" ]; then 
        printf "Execute? Y/N: "
        while true
        do
          read -r ans
          case ${ans} in
           [yY]* ) printf "\\n🔫 LETS DO THIS 🔫\\n" && break;;
           [nN]* ) printf "\\n🔥 CRISIS AVERTED 🔥\\n" && exit;;
           * )     printf "Y/N: ";;
          esac
        done
    fi
}

stay_strapped () {
    for strap in ${straps}; do
        if [[ ${strap} = "strapped" ]]; then continue; fi
        if [[ ${strap_repo} =~ ${url_regex} ]]; then
            source /dev/stdin <<< "$(curl -s "${strap_repo}/${strap}/${strap}.sh")"
        else
            source "${strap_repo}/${strap}/${strap}.sh"
        fi
        echo -e "\\n${C_GREEN}Strap: ${C_BLUE}${strap}${C_REG}"
        strapped_"${strap}"_before "${yml_file}"
        strapped_"${strap}" "${yml_file}"
        strapped_"${strap}"_after "${yml_file}"
    done
}

check_deps
verify_config
ask_permission
stay_strapped
