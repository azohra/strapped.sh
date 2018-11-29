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

create_file () {
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
  echo -e "$1" | wc -w 
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

  echo -e "${emoji_string}"
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

  echo -e "${ex}"
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

  # Iterate over top_level vars
  for var in ${vars}; do
    echo -e "\\tlocal ${var}"
  done

  routines=$( get_routines "${file}" )

  for routine in ${routines}; do
    fields=$( get_inputs "${routine}" )

    for field in ${fields}; do
      echo -e "\\tlocal ${field}"
    done

  done
  echo -e "\\tlocal i=0"
  echo -e "\\tlocal input=\${1}\\n"
}

function generate_routines() {
# $(q_count "$input" "ln")
  local routines
  local fields
  local cmd
  local msg
  local emoji
  local commands

  routines=$( get_routines "${file}" )

  for routine in ${routines}; do
    

    echo -e "\\tfor (i=0, i<\$( q_count \"\${input}\" \"${routine}\" ); do"

    fields=$( get_inputs "${routine}" )
    emoji=$( get_emoji "${routine}" )
    msg=$( get_message "${routine}" )
    commands=$( get_commands "${routine}" )

    for field in ${fields}; do
      echo -e "\\t\\t${field}=\$(q \"\${input}\" \"${routine}.\\\\\\[\${i}\\\\].${field}\")"
    done

    echo -e "\\t\\techo -e -e \"${emoji} ${msg}\""

    while read -r cmd; do
      echo -e "\\t\\t${cmd}"
    done <<< "${commands}"

    echo -e "\\tdone\\n"

  done
  
}

function dep_check_string() {
  echo -e "if ! ${1} ${2} > /dev/null; then echo -e \"ERROR ${1} is missing\" && exit; fi"
}

function generate_deps_check() {
  local deps
  local checks="-v -V --version"

  deps=$( get_deps )

  echo -e "\\tlocal __deps=\"${deps}\""
  echo -e "\\tlocal __checks=\"${checks}\""
  echo -e "\\tlocal __woo=\"\"\\n"

  echo -e "\\tfor dep in \${__deps}; do"
  echo -e "\\t\\tfor check in \${__checks}; do"
  echo -e "\\t\\t\\tif \${dep} \${check} &> /dev/null; then __woo=1; fi"
  echo -e "\\t\\tdone"
  echo -e "\\tdone"

  echo -e "\\tif [[ ! \"\${__woo}\" = \"1\"]]; then echo -e \"deps not met\" && exit 2; fi\\n"

}

function generate_func_start() {
  echo -e "function strapped_${namespace}() {"
}

function generate_func_end() {
  echo -e "}"
}

namespace=$( q "${file}" "namespace" )


strap_location="straps/${namespace}/${version}"

mkdir -p "straps/${namespace}"
mkdir -p "${strap_location}"

create_file "$( generate_docs )" "${strap_location}/README.md"
create_file "$( generate_func_start )" "${strap_location}/${namespace}.sh"

update_file "$( generate_deps_check )" "${strap_location}/${namespace}.sh"
update_file "$( generate_local_vars )" "${strap_location}/${namespace}.sh"
update_file "$( generate_routines )" "${strap_location}/${namespace}.sh"
update_file "$( generate_func_end )" "${strap_location}/${namespace}.sh"
