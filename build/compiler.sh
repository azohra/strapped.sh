#!/bin/bash

if [ ! -f "${1}" ]; then echo "Config Could Not Be Loaded!" && exit 2; fi
yml_file=$1
parent_name=$(yq read ${yml_file} -j | jq -r "keys[0]")
parent_count=$(yq read ${yml_file} -j | jq -r ".${parent_name} | length")
iterator_array=(i j k l m n o p q r s t u v w x y z)

# Make doc/straps folder if it doesn't exist
echo -e "[Strap Compiler] creating strap for ${parent_name} in _gen/${parent_name}"
mkdir -p "_gen/"
mkdir -p "_gen/${parent_name}"

echo -e "[Strap Compiler] compiling strap"
echo -e "#!/bin/bash" > "_gen/${parent_name}/${parent_name}.sh"
echo -e "strapped_${parent_name}_before () {\n\tif ! ${parent_name} -V > /dev/null; then echo \":${parent_name}: ${parent_name} is missing\" && exit; fi\n}\n" >> "_gen/${parent_name}/${parent_name}.sh"

echo -e "strapped_${parent_name} () {" >> "_gen/${parent_name}/${parent_name}.sh"

#local variable generator
for (( i=0; i < parent_count; i++ )); do
    sub_parent_name=$(yq read ${yml_file} -j | jq -r ".${parent_name} | keys[${i}]")
    echo -e "\tlocal ${sub_parent_name}_count" >> "_gen/${parent_name}/${parent_name}.sh"
    property_count=$(yq read ${yml_file} -j | jq -r ".${parent_name}.${sub_parent_name}[0] | keys | length")
    for (( j=0; j<property_count; j++ )); do
        property_name=$(yq read ${yml_file} -j | jq -r ".${parent_name}.${sub_parent_name}[0] | keys[${j}]")
        echo -e "\tlocal ${property_name}" >> "_gen/${parent_name}/${parent_name}.sh"
    done
    
done
echo -e "\t" >> "_gen/${parent_name}/${parent_name}.sh"

#count variable generator
for (( k=0; k < parent_count; k++ )); do
    sub_parent_name=$(yq read ${yml_file} -j | jq -r ".${parent_name} | keys[${k}]")
    echo -e "\t${sub_parent_name}_count=\$(yq read "\${1}" -j | jq -r \".${parent_name}.${sub_parent_name} | length\")" >> "_gen/${parent_name}/${parent_name}.sh"
done
echo -e "\t" >> "_gen/${parent_name}/${parent_name}.sh"

#for loop generator
for (( l=0; l < parent_count; l++ )); do
  sub_parent_name=$(yq read ${yml_file} -j | jq -r ".${parent_name} | keys[${l}]")
  property_count=$(yq read ${yml_file} -j | jq -r ".${parent_name}.${sub_parent_name}[0] | keys | length")
  iterator=$(echo ${iterator_array[${l}]})
  echo -e "\tfor (( ${iterator}=0; ${iterator}<${sub_parent_name}_count; ${iterator}++ )); do" >> "_gen/${parent_name}/${parent_name}.sh"
  for (( m=0; m < property_count; m++ )); do
    property_name=$(yq read ${yml_file} -j | jq -r ".${parent_name}.${sub_parent_name}[0] | keys[${m}]")
    echo -e "\t\t${property_name}=\$(yq read \"\${1}\" -j | jq -r \".${parent_name}.${sub_parent_name}[\${i}].${property_name}\")" >> "_gen/${parent_name}/${parent_name}.sh"
    echo -e "\t\techo \"#do shit with \${${property_name}}\"" >> "_gen/${parent_name}/${parent_name}.sh"
  done
echo -e "\tdone" >> "_gen/${parent_name}/${parent_name}.sh"
  echo -e "\t" >> "_gen/${parent_name}/${parent_name}.sh"
done
echo -e "}\n" >> "_gen/${parent_name}/${parent_name}.sh"
echo -e "strapped_${parent_name}_after () {\n\treturn\n}" >> "_gen/${parent_name}/${parent_name}.sh"

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
$(cat ${yml_file})
\`\`\`"

# Write README file for the new strap
echo -e "[Strap Compiler] gererating docs"
echo -e "${readme}" > "_gen/${parent_name}/README.md"
