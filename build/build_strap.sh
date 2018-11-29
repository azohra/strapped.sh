#!/bin/bash

# Helpers
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

# Read the config file, and get data under the strap heading
file=$( awk -f parser.awk "$1")
file=$( q_sub "${file}" "strap" )

version=$( q "${file}" "version" )

# Helper functions
function get_routines() {
  q_children "${file}" "routines"
}

function get_message() {
  q "${file}" "routines.${1}.message"
}

function get_commands() {
  q "${file}" "routines.${1}.exec"
}

function get_deps() {
  q "${file}" "deps" | tr '\n' ' '
}

function get_before_commands() {
  q "${file}" "before"
}

function get_after_commands() {
  q "${file}" "after"
}

function get_emoji() {
  q "${file}" "routines.${1}.emoji"
}

function get_inputs() {
  q_children "${file}" "routines.$1.input.\\[0\\]" | tr '\n' ' '
}

function get_value_for_routine_input() {
  q "${file}" "routines.$1.input.\\[0\\].$2"
}

function len() {
  echo "$1" | wc -w 
}

function generate_emoji_string() {
  local routines
  local emoji
  local emoji_string=""
  routines=$( get_routines "${file}" )

  for routine in ${routines}; do
    emoji=$(q "${file}" "routines.${routine}.emoji")
    emoji_string+="$emoji [${routine}] "
  done

  echo "${emoji_string}"
}

# Generate the chart in the documentation
function generate_chart() {
  local emoji
  local desc
  local comp
  local deps
  local chart="| Attribute | Value |\\n|----:|----|\\n"

  emoji=$( generate_emoji_string )
  desc=$( q "${file}" "description" )
  comp=$( q "${file}" "compatability" | tr '\n' ' ')
  deps=$( get_deps )

  chart+="| Namespace | ${namespace} |\\n"
  chart+="| Emoji | ${emoji} |\\n"
  chart+="| Description | ${desc} |\\n"
  chart+="| Dependencies | ${deps} |\\n"
  chart+="| Compatability | ${comp} |\\n"

  echo "${chart}"
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
    field_count=$( q_children "${file}" "routines.${routine}.input.\\[0\\]" )
    field_count=$( len "${field_count}")
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

  echo "${ex}"
}

function generate_docs() {
  echo -e "# ${namespace}\\n"

  echo -e "$( generate_chart )"

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

  vars=$( q "${file}" "vars" )
  echo "\\t# Declaring local variables"
  # Iterate over top_level vars
  for var in ${vars}; do
    echo "\\tlocal ${var}"
  done

  routines=$( get_routines "${file}" )

  for routine in ${routines}; do
    fields=$( get_inputs "${routine}" )

    for field in ${fields}; do
      echo "\\tlocal ${field}"
    done

  done
  echo "\\tlocal i=0"
  echo "\\tlocal input=\${1}\\n"
}

function generate_routines() {
  local routines
  local fields
  local cmd
  local msg
  local emoji
  local commands

  routines=$( get_routines "${file}" )

  for routine in ${routines}; do
    
    echo "\\t# performing functionality for ${routine}"
    echo "\\tfor (i=0, i<\$( q_count \"\${input}\" \"${routine}\"), i++); do"

    fields=$( get_inputs "${routine}" )
    emoji=$( get_emoji ${routine} )
    msg=$( get_message ${routine} )
    commands=$( get_commands ${routine} )

    echo "\\t\\t# Getting fields"

    for field in ${fields}; do
      echo "\\t\\t${field}=\$(q \"\${input}\" \"${routine}.\\\\\[\${i}\\\\\].${field}\")"
    done

    if [[ ${message} ]]; then
      echo "\\t\\t# Writing message"
      echo "\\t\\techo -e \"${emoji} ${msg}\""
    fi

    echo "\\t\\t# Executing the command(s)"

    while read -r cmd; do
      echo -e "\\t\\t${cmd}"
    done <<< "${commands}"

    echo "\\tdone\\n"

  done
  
}

function dep_check_string() {
  echo "if ! ${1} ${2} > /dev/null; then echo \"ERROR ${1} is missing\" && exit; fi"
}

function generate_deps_check() {
  local deps
  local checks="-v -V --version"

  deps=$( get_deps )

  echo "\\t# Variables to hold the deps and corresponding checks"
  echo "\\tlocal __deps=\"${deps}\""
  echo "\\tlocal __checks=\"${checks}\""
  echo "\\tlocal __woo=\"\"\\n"

  echo "\\t# Performing each check for each dep"
  echo "\\tfor dep in \${__deps}; do"
  echo "\\t\\tfor check in \${__checks}; do"
  echo "\\t\\t\\tif \${dep} \${check} &> /dev/null; then __woo=1; fi"
  echo "\\t\\tdone"
  echo "\\tdone\\n"

  echo "\\t# Deciding if the dependancy has been satisfied"
  echo "\\tif [[ ! \"\${__woo}\" = \"1\"]]; then echo \"deps not met\" && exit 2; fi\\n"
}

function generate_before_tasks() {
  local commands

  commands=$( get_before_commands )

  if [[ "${commands}" ]]; then 
    echo "\\t# Commands that run before the routines start"

    while read -r cmd; do
      echo -e "\\t${cmd}"
    done <<< "${commands}"

    echo "\\n"
  fi
}

function generate_after_tasks() {
  local commands

  commands=$( get_after_commands )

  if [[ "${commands}" ]]; then 
    echo "\\t# Commands that run after the routines finish"

    while read -r cmd; do
      echo -e "\\t${cmd}"
    done <<< "${commands}"
  fi
}

function generate_func_start() {
  echo "function strapped_${namespace}() {"
}

function generate_func_end() {
  echo "}"
}

namespace=$( q "${file}" "namespace" )

# See if the version exists. If not, build it.

mkdir -p straps/${namespace}
mkdir -p straps/${namespace}/latest

overwrite_file "$( generate_docs )" "straps/${namespace}/latest/README.md"

overwrite_file "$( generate_func_start )" "straps/${namespace}/latest/${namespace}.sh"

update_file "$( generate_deps_check )" "straps/${namespace}/latest/${namespace}.sh"
update_file "$( generate_local_vars )" "straps/${namespace}/latest/${namespace}.sh"
update_file "$( generate_before_tasks )" "straps/${namespace}/latest/${namespace}.sh"
update_file "$( generate_routines )" "straps/${namespace}/latest/${namespace}.sh"
update_file "$( generate_after_tasks )" "straps/${namespace}/latest/${namespace}.sh"
update_file "$( generate_func_end )" "straps/${namespace}/latest/${namespace}.sh"
