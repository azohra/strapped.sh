#!/bin/bash

if [[ `ls straps` =~ ${1} ]]; then
    >&2 echo "[Strap Generator] Error: strap already exists"
    exit 2
fi

# String containing the strap README template
readme="# ${1}

| Attribute     | Value                                     |
|--------------:|-------------------------------------------|
| Namespace     | ${1}                                      |
| Emoji         | An emoji that best describes your strap   |
| Description   | A description of your strap               |
| Dependencies  | ex: Git                                   |
| Compatability | ex: Unix, Mac OS                          |

### Configuration

\`\`\`yml
${1}:
  - { key_1: val_1, key_2: val_2 }

\`\`\`"

# String containing the strap shell script template
outline="# Hook that is called before the strap
strapped_${1}_before () { 
  return
}

# Hook that performs the strap
strapped_${1} () {
  echo \"Strapping ${1}\"
}

# Hook that is called after the strap
strapped_${1}_after () { 
  return   
}"

# Make doc/straps folder if it doesn't exist
echo "[Strap Generator] creating directory for ${1} in strap/"
mkdir -p straps/${1}

# Write README file for the new strap
echo "[Strap Generator] writing sample documentation for ${1} in strap/${1}/README.md"
echo "${readme}" > straps/${1}/README.md

# Write README file for the new strap
echo "[Strap Generator] laying out strap template for ${1} in strap/${1}/${1}.sh"
echo "${outline}" > straps/${1}/${1}.sh
