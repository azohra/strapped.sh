#!/bin/bash
# shellcheck source=/dev/null

set -e

C_GREEN="\\033[32m"
C_BLUE="\\033[34m"
C_REG="\\033[0;39m"

pretty_print () {  
    local key=${1}
    local value=${2}

    echo -e "${C_GREEN}${key}:${C_BLUE} ${value} ${C_REG}"
}

overwrite_file () {
    echo -e "${1}" > "${2}"

}

update_file () {
    echo -e "${1}" >> "${2}"

}

