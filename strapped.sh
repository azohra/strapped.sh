#!/bin/bash
# shellcheck source=/dev/null

set -e
echo ""
C_GREEN="\\033[32m"
C_BLUE="\\033[94m"
C_REG="\\033[0;39m"
STRAPPED_DEBUG=""
custom_straps=""
auto_approve=""
base_repo="https://raw.githubusercontent.com/azohra/strapped/master/straps"
yml_location="https://raw.githubusercontent.com/azohra/strapped/master/yml/first_run.yml"
url_regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'

# shellcheck disable=SC2034 
YSH_LIB=1;
# shellcheck disable=SC1091
source /dev/stdin <<< "$(curl -s https://raw.githubusercontent.com/azohra/yaml.sh/v0.1.4/ysh)"

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

function usage {
    echo -e "\\nUsage: strapped [flags]\\n"
    echo "flags:"
    echo "  -u, --upgrade               upgrade strapped to the latest version"
    echo "  -v, --version               print the current strapped version"
    echo "  -a, --auto                  do not prompt for confirmation"
    echo "  -y, --yml file/url          path to a valid strapped yml config"
    echo "  -l, --lint                  exits after reading config file"
    echo "  -s, --straps string         run a subset of your config. Comma seperated."
    echo "  -h, --help                  prints this message"
    exit 1
}

function upgrade {
    rm /usr/local/bin/strapped
    curl -s https://stay.strapped.sh | sh
    pretty_print ":announce:" "Strapped::Upgraded Successfully!"
    exit 0
}

while [ $# -gt 0 ] ; do
    case "$1" in
    -d|--debug)
        STRAPPED_DEBUG="true"
    ;;
    -u|--upgrade)
        upgrade
    ;;
    -y|--yml)
        yml_location="$2"
        shift # extra value 
    ;;
    -l|--lint)
        # init_parser
        ysh "${2}" > /dev/null
        # awk -v force_complete=1 "${parser}" "${2}" > /dev/null
        exit $?
    ;;
    -r|--repo)
        base_repo="$2"
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

parse_config() {
    # Check for YML
    if [[ "${yml_location}" =~ ${url_regex} ]]; then config=$(curl -s "${yml_location}" | ysh ); else config=$(ysh -f "${yml_location}"); fi
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
    echo -e "\\n"
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
            source /dev/stdin <<< "$(curl -s "${strap_repo}/${strap}/${version}/${strap}.sh")"
        else
            source "${strap_repo}/${strap}/${version}/${strap}.sh"
        fi
        pretty_print ":announce:" "\\n${strap}::${version} from ${strap_repo}"

        strapped_"${strap}" "${strap_config}"
    done
}

# init_parser
parse_config
parse_strapped_repo
create_strap_array
ask_permission "Are you ready to get strapped?"
stay_strapped
