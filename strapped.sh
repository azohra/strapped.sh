#!/bin/bash
# shellcheck source=/dev/null
# shellcheck disable=SC2068
set -e

C_GREEN="\\033[32m"
C_BLUE="\\033[34m"
C_REG="\\033[0;39m"

uh_oh=""
custom_straps=""
auto_approve=""
repo_location="https://raw.githubusercontent.com/azohra/strapped/master/straps"
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
    -r|--repo)
        repo_location="$2"
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

#make this more awesome by asking to install missing deps and also making it OS specific
check_deps () {
    deps="brew yq jq"
    for dep in $deps; do
        if ! $dep --version &> /dev/null; then   
            if [[ ${dep} = "brew2" ]]; then
                ask_permission "brew is required. Can I install it?"
                ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
            else
                ask_permission "${dep} is required. Can I install it via brew?"
                brew install $dep
            fi
        fi
    done
}

verify_config () {
    # Check for YML
    if [[ "${yml_location}" =~ ${url_regex} ]]; then json=$(curl -s "${yml_location}" | yq r - -j); else json=$(yq r "${yml_location}" -j); fi
    if [ ! "${json}" ]; then echo "Config not found" && exit 2;else echo -e "\\n${C_GREEN}Using Config From: ${C_BLUE}${yml_location}${C_REG}"; fi
    
    # Check for Repo
    if [ "$(jq -r ".strapped.repo" <<< "${json}")" != "null" ]; then repo_location="$(jq -r ".strapped.repo" <<< "${json}")"; fi
    if [ ! "${repo_location}" ]; then echo "Repo not found" && exit 2;else echo -e "${C_GREEN}Using Straps From: ${C_BLUE}${repo_location}${C_REG}"; fi

    # Create Strap Array
    if [[ "${custom_straps}" ]]; then straps="${custom_straps//,/ }"; else straps=$(yq r "${yml_location}" | grep -v ' .*' | sed 's/.$//' | tr '\n' ' '); fi
    straps=${straps/strapped /}
    if [ ! "${straps}" ]; then echo "Straps not found" && exit 2;else echo -e "${C_GREEN}Requested Straps :${C_BLUE} ${straps} ${C_REG}"; fi
}

ask_permission () {  
    local message
    message=${1}
    echo -e "\n${C_GREEN}Question:${C_BLUE} ${message} ${C_REG}"
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
    for strap in ${straps}; do
        if [[ ${repo_location} =~ ${url_regex} ]]; then
            source /dev/stdin <<< "$(curl -s "${repo_location}/${strap}/${strap}.sh")"
        else
            source "${repo_location}/${strap}/${strap}.sh"
        fi
        strap_json=$(jq -r ."${strap}" <<< "${json}")
        echo -e "\\n${C_GREEN}Strap: ${C_BLUE}${strap}${C_REG}"
        strapped_"${strap}"_before "${strap_json}"
        strapped_"${strap}" "${strap_json}"
        strapped_"${strap}"_after "${strap_json}"
    done
}

check_deps
verify_config
ask_permission "Are you ready to get strapped?"
stay_strapped
