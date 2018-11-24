#!/bin/bash
url_regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'
if [ ! -f "${1}" ]; then echo "[Strap Compiler] You must pass a YML file to parse!" && exit 2; fi
if [[ "${1}" =~ $url_regex ]]; then 
  json=$(curl -s "${1}" | yq r - -j); 
else 
  json=$(yq r "${1}" -j); 
fi
if [ ! "${json}" ]; then echo "[Strap Compiler] File appears empty" && exit 2; fi
    
parent_name=$(jq -r "keys[0]"  <<< "${json}")
parent_count=$(jq -r ".${parent_name} | length" <<< "${json}")
iterator_array=(i j k l m n o p q r s t u v w x y z)

# Make doc/straps folder if it doesn't exist
echo -e "[Strap Compiler] creating strap for ${parent_name} in _gen/${parent_name}"
mkdir -p "_gen/"
mkdir -p "_gen/${parent_name}"

echo -e "[Strap Compiler] compiling strap"
echo -e "#!/bin/bash" > "_gen/${parent_name}/${parent_name}.sh"
echo -e "strapped_${parent_name}_before () {\\n\\tif ! ${parent_name} -V > /dev/null; then echo \":${parent_name}: ${parent_name} is missing\" && exit; fi\\n}\\n" >> "_gen/${parent_name}/${parent_name}.sh"

echo -e "strapped_${parent_name} () {" >> "_gen/${parent_name}/${parent_name}.sh"

#local variable generator
for (( i=0; i < parent_count; i++ )); do
    sub_parent_name=$(jq -r ".${parent_name} | keys[${i}]" <<< "${json}")
    echo -e "\\n\\tlocal ${sub_parent_name}_count" >> "_gen/${parent_name}/${parent_name}.sh"
    property_count=$(jq -r ".${parent_name}.${sub_parent_name}[0] | keys | length" <<< "${json}")
    for (( j=0; j<property_count; j++ )); do
        property_name=$(jq -r ".${parent_name}.${sub_parent_name}[0] | keys[${j}]" <<< "${json}")
        echo -e "\\tlocal ${property_name}" >> "_gen/${parent_name}/${parent_name}.sh"
    done
    
done
#json variable generator
echo -e "\\n\\tlocal json \\n \\tjson=\${1}\\n" >> "_gen/${parent_name}/${parent_name}.sh"

#count variable generator
for (( k=0; k < parent_count; k++ )); do
    sub_parent_name=$(jq -r ".${parent_name} | keys[${k}]" <<< "${json}")
    echo -e "\\t${sub_parent_name}_count=\$(jq -r \".${sub_parent_name} | length\" <<< \"\${json}\")" >> "_gen/${parent_name}/${parent_name}.sh"
done
echo -e "\\t" >> "_gen/${parent_name}/${parent_name}.sh"

#for loop generator
for (( l=0; l < parent_count; l++ )); do
  sub_parent_name=$(jq -r ".${parent_name} | keys[${l}]" <<< "${json}")
  property_count=$(jq -r ".${parent_name}.${sub_parent_name}[0] | keys | length" <<< "${json}")
  iterator="${iterator_array[${l}]}"
  echo -e "\\tfor (( ${iterator}=0; ${iterator} < ${sub_parent_name}_count; ${iterator}++ )); do" >> "_gen/${parent_name}/${parent_name}.sh"
  for (( m=0; m < property_count; m++ )); do
    property_name=$(jq -r ".${parent_name}.${sub_parent_name}[0] | keys[${m}]" <<< "${json}")
    echo -e "\\t\\t${property_name}=\$(jq -r \".${sub_parent_name}[\${${iterator}}].${property_name}\" <<< \"\${json}\")" >> "_gen/${parent_name}/${parent_name}.sh"
    echo -e "\\t\\techo \"#do a thing with \${${property_name}}\"" >> "_gen/${parent_name}/${parent_name}.sh"
  done
echo -e "\\tdone" >> "_gen/${parent_name}/${parent_name}.sh"
  echo -e "\\t" >> "_gen/${parent_name}/${parent_name}.sh"
done
echo -e "}\\n" >> "_gen/${parent_name}/${parent_name}.sh"
echo -e "strapped_${parent_name}_after () {\\n\\treturn\\n}" >> "_gen/${parent_name}/${parent_name}.sh"

# String containing the strap README template
readme="# ${parent_name}

| Attribute     | Value                                     |
|--------------:|-------------------------------------------|
| Namespace     | ${parent_name}                          |
| Emoji         | An emoji that best describes your strap   |
| Description   | A description of your strap               |
| Dependencies  | ex: Git                                   |
| Compatability | ex: Unix, Mac OS                          |

## Configuration

\`\`\`yml
$(cat "${1}")
\`\`\`"

# Write README file for the new strap
echo -e "[Strap Compiler] gererating docs"
echo -e "${readme}" > "_gen/${parent_name}/README.md"
