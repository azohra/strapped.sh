#!/bin/bash
# shellcheck source=/dev/null

set -e
function usage {
    echo -e "\nUsage: strapped [flags]\n"
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
        __yml_loc="$2"
        shift # extra value 
    ;;
    -s|--straps)
        __passed_straps="$2"
        shift # extra value 
    ;;
    -a|--auto)
        __auto=yes
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

C_GREEN="\\033[32m"
C_BLUE="\\033[34m"
C_REG="\\033[0;39m"
__url_regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'
__yml_loc="${HOME}/.strapped/strapped.yml"


verify_config () {
    if ! yq -V > /dev/null; then echo "😞 yq is required to run strapped.sh" && exit; fi 
    if ! jq -V > /dev/null; then echo "😞 jq required to run strapped.sh" && exit; fi 
    if [[ ${__yml_loc} =~ ${__url_regex} ]]; then 
        curl -s "${__yml_loc}" --output /tmp/strapped.yml > /dev/null
        __config_file='/tmp/strapped.yml'
    else
        __config_file=${__yml_loc}
    fi
    if [ ! -f "${__config_file}" ]; then echo "Config Could Not Be Loaded!" && exit 2; fi
    echo -e "\\n${C_GREEN}Using Config From: ${C_BLUE}${__yml_loc}${C_REG}" 
}

load_strapped () {
    __strap_repo=$(yq read "${__config_file}" -j | jq -r '.strapped.repo')
    if [[ "${__strap_repo}" = "null" ]]; then echo "You must provide a strap repo" && exit 2; fi
    if [[ ${__strap_repo} =~ ${__url_regex} ]]; then
        source /dev/stdin <<< "$(curl -s "${__strap_repo}"/strapped.sh)"
    else
        source "${__strap_repo}/strapped.sh"
    fi
    echo -e "${C_GREEN}Using Straps From: ${C_BLUE}${__strap_repo}${C_REG}"
}

verify_config
load_strapped
strapped_before
strapped 
strapped_after
