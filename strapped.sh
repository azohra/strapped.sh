#!/bin/bash
# shellcheck source=/dev/null

set -e
custom_straps="0"
auto_approve="0"
yml_location="${HOME}/.strapped/strapped.yml"
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

C_GREEN="\\033[32m"
C_BLUE="\\033[34m"
C_REG="\\033[0;39m"




check_deps () {
    if ! yq -V > /dev/null; then echo "😞 yq is required to run strapped.sh" && exit; fi 
    if ! jq -V > /dev/null; then echo "😞 jq required to run strapped.sh" && exit; fi 
}

verify_config () {
    if [[ ${yml_location} =~ ${url_regex} ]]; then 
        curl -s "${yml_location}" --output /tmp/strapped.yml
        yml_file='/tmp/strapped.yml'
    else
        yml_file=${yml_location}
    fi
    if [ ! -f "${yml_file}" ]; then echo "Config Could Not Be Loaded!" && exit 2; fi
    echo -e "\\n${C_GREEN}Using Config From: ${C_BLUE}${yml_location}${C_REG}" 
}

load_strapped () {
    strap_repo=$(yq read "${yml_file}" -j | jq -r '.strapped.repo')
    if [[ "${strap_repo}" = "null" ]]; then echo "You must provide a strap repo" && exit 2; fi
    if [[ ${strap_repo} =~ ${url_regex} ]]; then
        source /dev/stdin <<< "$(curl -s "${strap_repo}"/strapped/strapped.sh)"
    else
        source "${strap_repo}/strapped/strapped.sh"
    fi
    echo -e "${C_GREEN}Using Straps From: ${C_BLUE}${strap_repo}${C_REG}"
}

check_deps 
verify_config
load_strapped

strapped_before "${yml_file}" "${custom_straps}" "${auto_approve}"
strapped "${strap_repo}" "${yml_file}" "${url_regex}"
strapped_after
