#!/bin/bash

set -e

# shellcheck disable=SC2034 
YSH_LIB=1;
# shellcheck disable=SC1091
source /dev/stdin <<< "$(curl -s https://raw.githubusercontent.com/azohra/yaml.sh/v0.1.4/ysh)"

# Helpers
pretty_print () {  
    local key=${1}
    local value=${2}

    echo -e "${C_GREEN}${key}:${C_BLUE} ${value} ${C_REG}"
}

trim() {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   
    echo -n "$var"
}

create_file () {
    echo -e "${1}" > "${2}"

}

update_file () {
  if [[ ${1} ]]; then
    echo -e "${1}" >> "${2}"
  else
    true
  fi 
}

# Query stuff
q() {
    grep -E "^$2" <<< "$1" | sed 's/^.*=//'
}

q_sub() {
    grep -E "^$2" <<< "$1" | sed "s/^$2\\.//"
}

q_count() {
    q_sub "$1" "$2" | grep -oE "^\\[[0-9]+\\]" | uniq | wc -l
}

q_children() {
  q_sub "$1" "$2" | sed "s/\\..*$//" | sed "s/=.*$//"| uniq
}

# Helper functions
function get_routines() {
  ysh -T "${file}" -s "routines" -t
}

function get_message() {
  ysh -T "${file}" -Q "routines.${1}.message"
}

function get_commands() {
  ysh -T "${file}" -Q "routines.${1}.exec"
}

function get_deps() {
  local i=0
  local names=""
  for ((i=0; i<$(ysh -T "${file}" -l deps -c); i++)); do
    names+="$( ysh -T "${file}" -l deps -i ${i} -Q name ) "
  done

  echo "${names}"
}

function get_dep_name() {
  ysh -T "${file}" -l deps -i "${1}" -Q name
}

function get_dep_message() {
  local i=0
  local msg
  local message=""
  for ((i=0; i<$(ysh -T "${file}" -l deps -i "${1}" -l msg -c); i++)); do
    msg=$( ysh -T "${file}" -l deps -i "${1}" -l msg -i "${i}" )
    message+="${msg:1:${#msg}-2} \\\\n"
  done

  echo "${message}"
}

function get_before_commands() {
  ysh -T "${file}" -l "before"
}

function get_after_commands() {
  ysh -T "${file}" -l "after"
}

function get_emoji() {
  ysh -T "${file}" -Q "routines.${1}.emoji"
}

function get_inputs() {
  ysh -T "${file}" -s "routines.${1}.input" -i 0 -t
}

function get_value_for_routine_input() {
  ysh -T "${file}" -s "routines.${1}.input" -i 0 -Q "${2}"
}

function len() {
  echo -e "$1" | wc -w 
}

function generate_emoji_string() {
  local routines
  local emoji
  local emoji_string=""
  routines=$( get_routines "${file}" )

  for routine in ${routines}; do
    emoji=$(ysh -T "${file}" -Q "routines.${routine}.emoji")
    emoji_string+="$emoji [${routine}] "
  done

  echo -e "${emoji_string}"
}

# Generate the chart in the documentation
function generate_chart() {
  local emoji
  local desc
  local comp
  local deps
  local chart="| Attribute     | Value |\\n|--------------:|----|\\n"

  emoji=$( generate_emoji_string )
  desc=$( ysh -T "${file}" -Q "description" )
  comp=$( ysh -T "${file}" -Q "compatability" | sed "s/.*=//" | tr '\n' ' ')
  deps=$( get_deps )

  chart+="| Namespace     | ${namespace} |\\n"
  chart+="| Emoji         | ${emoji} |\\n"
  chart+="| Description   | ${desc} |\\n"
  chart+="| Dependencies  | ${deps} |\\n"
  chart+="| Compatability | ${comp} |\\n"

  echo -e "${chart}"
}

# Generate the example data strucutre in the documentation
function generate_example() {
  local ex="\`\`\`yml\\n"
  local routines
  local fields
  local field_count
  local field_val
  local counter=0

  routines=$( get_routines "${file}" )

  ex+="${namespace}:\\n"
  for routine in ${routines}; do
    ex+="  ${routine}:\\n"

    fields=$( get_inputs "${routine}" )

    # Get a 0-indexed iterator
    field_count=$( ysh -T "${file}" -s routines."${routine}".input -i 0 -t | tr '\n' ' ' | wc -w )
    ((field_count--))

    # Maybe verify if the user has specified an input

    ex+="    - { "
    counter=0
    for field in ${fields}; do
      field_val=$( get_value_for_routine_input "${routine}" "${field}" )

      ex+="${field}: ${field_val}"

      if [[ "${counter}" != "${field_count}" ]]; then
        ex+=", "
      fi

      ((counter++))
    done

    ex+=" }\\n"
  done

  ex+="\`\`\`"

  echo -e "${ex}"
}

function generate_docs() {
  echo -e "# ${namespace} :: ${version}\\n"

  echo -e "$( generate_chart )\\n"

  echo -e "## Configuration\\n"

  echo -e "$( generate_example )"
}


#
#   Compile strap
#

function generate_local_vars() {
  local vars
  local routines
  local fields

  routines=$( get_routines "${file}" )

  if [[ ${routines} ]]; then
    for routine in ${routines}; do
      echo -e "\\n\\t# Declaring local variables for the '${routine}' routine"
      fields=$( get_inputs "${routine}" )

      for field in ${fields}; do
        echo -e "\\tlocal ${field}"
      done
    done

    echo -e "\\tlocal input=\${1}"
  fi
  
  # Iterate over top_level vars
  if [[ $(ysh -T "${file}" -c vars) -ne 0 ]]; then

    vars=$( ysh -T "${file}" -L "vars" | tr '\n' ' ')

    echo -e "\\n\\t# Declaring top-level local strap variables"

    for var in ${vars}; do
      echo -e "\\tlocal ${var}"
    done

    echo -e "\\n\\t# Setting top-level local strap variables"

    for var in ${vars}; do
      echo -e "\\t${var}=\$( ysh -T \"\${input}\" -Q ${var})"
    done
  fi 

}

function generate_routines() {
  local routines
  local fields
  local cmd
  local msg
  local emoji
  local commands

  routines=$( get_routines "${file}" )

  if [[ ${routines} ]]; then
    echo -e "\\n\\t# Initialize array iterator"
    echo -e "\\tlocal i=0"
  else
    echo -e "\\ttrue"
  fi 

  for routine in ${routines}; do
    
    echo -e "\\n\\t# performing functionality for routine '${routine}'"
    echo -e "\\tfor ((i=0; i<\$( ysh -T \"\${input}\" -c ${routine} ); i++)); do"

    fields=$( get_inputs "${routine}" )
    emoji=$( get_emoji "${routine}" )
    msg=$( get_message "${routine}" )
    commands=$( get_commands "${routine}" )

    echo -e "\\n\\t\\t# Getting fields for routine '${routine}'"

    for field in ${fields}; do
      echo -e "\\t\\t${field}=\$( ysh -T \"\${input}\" -l ${routine} -i \${i} -Q ${field} )"
    done

    if [[ ${msg} ]]; then
      echo -e "\\n\\t\\t# Writing message for routine '${routine}'"
      echo -e "\\t\\tpretty_print \":info:\" \"${emoji} ${msg}\""
    fi

    echo -e "\\n\\t\\t# Executing the command(s) for routine '${routine}'"
  
    while read -r cmd; do
      echo -e "\\t\\trun_command \"${cmd}\""
    done <<< "${commands}"

    echo -e "\\tdone\\n"

  done
  
}

function dep_check_string() {
  echo -e "if ! ${1} ${2} > /dev/null; then echo -e \"ERROR ${1} is missing\" && exit; fi"
}

function generate_deps_check() {
  local deps
  local i=0
  local name
  local msg

  deps=$( get_deps )

  if [[ "${deps}" ]]; then 
    echo -e "\\t# Variables to hold the deps and corresponding checks"
    echo -e "\\tlocal __deps=\"${deps}\""
    echo -e "\\tlocal __resp"
  
    echo -e "\\t# Performing each check for each dep"
    echo -e "\\tfor dep in \${__deps}; do"
    echo -e "\\t\\tcommand -v \"\${dep}\" &> /dev/null"
    echo -e "\\t\\t__resp=\$?"
    echo -e "\\t\\tif [[ \$__resp -ne 0 ]]; then"
    echo -e "\\t\\t\\techo \"ERROR: dep \${dep} not found:\""
    echo -e "\\t\\t\\tcase \"\${dep}\" in"

    for ((i=0; i<$(ysh -T "${file}" -l deps -c); i++)); do
      name=$( get_dep_name ${i} )
      msg=$( get_dep_message ${i} )

      echo -e "\\t\\t\\t\"${name}\")"
      echo -e "\\t\\t\\t\\techo -e \"${msg}\""
      echo -e "\\t\\t\\t;;"
      # echo -e "\\t\\t\\t${msg}"
    done
    echo -e "\\t\\t\\tesac"

    echo -e "\\t\\t\\texit 1"
    echo -e "\\t\\tfi"
    echo -e "\\tdone\\n"
  fi
}

function generate_before_tasks() {
  local i=0
  local cmd
  command_count=$( ysh -T "${file}" -c before )

  if [[ ${command_count} -ne 0 ]]; then
    echo -e "\\t# Commands that run before the routines start"

    for ((i=0; i<$( ysh -T "${file}" -c before ); i++)); do
      cmd=$( ysh -T "${file}" -l before -i ${i} )
      echo -e "\\trun_command ${cmd}"
    done
  fi
}

function generate_after_tasks() {
  local i=0
  local cmd
  command_count=$( ysh -T "${file}" -c after )

  if [[ ${command_count} -ne 0 ]]; then
    echo -e "\\t# Commands that run after the routines finish"

    for ((i=0; i<$( ysh -T "${file}" -c after ); i++)); do
      cmd=$( ysh -T "${file}" -l after -i ${i} )
      echo -e "\\trun_command ${cmd}"
    done
  fi
}

function generate_func_start() {
  echo -e "#!/bin/bash \\n"
  echo -e "function strapped_${namespace}() {"
}

function generate_func_end() {
  echo -e "}"
}

# Read the config file, and get data under the strap heading
if [ ! -f "${1}" ]; then
  echo "spec not found!" && exit 2
fi

C_GREEN="\\033[32m"
C_BLUE="\\033[34m"
C_REG="\\033[0;39m"

file=$( ysh -f "$1" -s "strap")

# Load the version from the spec.yml
version=$( ysh -T "${file}" -Q "version" )
version=${version:="latest"}

# Load the namespace from the spec.yml
namespace=$( ysh -T "${file}" -Q "namespace" )

# Ensure the user has specified a proper namespace
if [[ ! "${namespace}" ]]; then
  echo "[Build] Error: could not find namespace for strap $1."
  echo "[Build] Fix: specify the namespace for your strap."
  exit 1
fi

# Ensure the user has specified a valid version number
if [[ "${version}" != "latest" ]]; then
  strap_location="straps/${namespace}/${version}"

  mkdir -p "straps/${namespace}"
  mkdir -p "${strap_location}"

  create_file "$( generate_docs )" "${strap_location}/README.md"
  create_file "$( generate_func_start )" "${strap_location}/${namespace}.sh"

  update_file "$( generate_deps_check )" "${strap_location}/${namespace}.sh"
  update_file "$( generate_before_tasks )" "${strap_location}/${namespace}.sh"
  update_file "$( generate_local_vars )" "${strap_location}/${namespace}.sh"
  update_file "$( generate_routines )" "${strap_location}/${namespace}.sh"
  update_file "$( generate_after_tasks )" "${strap_location}/${namespace}.sh"
  update_file "$( generate_func_end )" "${strap_location}/${namespace}.sh"

  rm -rf "straps/${namespace}/latest"
  cp -R "${strap_location}" "straps/${namespace}/latest"

  shasum -a 256 "${strap_location}/${namespace}.sh" > "${strap_location}/${namespace}.sh.DIGEST"
  cp "${strap_location}/${namespace}.sh.DIGEST" "straps/${namespace}/latest/${namespace}.sh.DIGEST"

else
  echo "[Build] Error: Invalid version field for strap ${namespace}"
  echo "[Build] Fix: add a version number to your strap, 'latest' does not count as a version number"
  exit 1
fi
