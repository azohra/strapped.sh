#!/bin/bash
parent_name=$(yq read playground.yml -j | jq -r "keys[0]")
parent_count=$(yq read playground.yml -j | jq -r ".${parent_name} | length")
iterator_array=(i j k l m n o p q r s t u v w x y z)

# Make doc/straps folder if it doesn't exist
echo -e "[Strap Generator] creating directory for ${parent_name} in strap/"
mkdir -p "../straps/${parent_name}"

echo -e "#!/bin/bash" > "../straps/${parent_name}/${parent_name}.sh"
echo -e "strapped_${parent_name}_before () {\n\tif ! ${parent_name} -V > /dev/null; then echo \":${parent_name}: ${parent_name} is missing\" && exit; fi\n}\n" >> "../straps/${parent_name}/${parent_name}.sh"

echo -e "strapped_${parent_name} () {" >> "../straps/${parent_name}/${parent_name}.sh"

#local variable generator
for (( i=parent_count; i>0; i-- )); do
    sub_parent_name=$(yq read playground.yml -j | jq -r ".${parent_name} | keys[${i}-1]")
    echo -e "\tlocal ${sub_parent_name}_count" >> "../straps/${parent_name}/${parent_name}.sh"
    property_count=$(yq read playground.yml -j | jq -r ".${parent_name}.${sub_parent_name}[0] | keys | length")
    for (( j=property_count; j>0; j-- )); do
        property_name=$(yq read playground.yml -j | jq -r ".${parent_name}.${sub_parent_name}[0] | keys[${j}-1]")
        echo -e "\tlocal ${property_name}" >> "../straps/${parent_name}/${parent_name}.sh"
    done
    
done
echo -e "\t" >> "../straps/${parent_name}/${parent_name}.sh"

#count variable generator
for (( k=parent_count; k>0; k-- )); do
    sub_parent_name=$(yq read playground.yml -j | jq -r ".${parent_name} | keys[${k}-1]")
    echo -e "\t${sub_parent_name}_count=\$(yq read "\${1}" -j | jq -r \".${parent_name}.${sub_parent_name} | length\")" >> "../straps/${parent_name}/${parent_name}.sh"
done
echo -e "\t" >> "../straps/${parent_name}/${parent_name}.sh"

#for loop generator
for (( l=parent_count; l>0; l-- )); do
  sub_parent_name=$(yq read playground.yml -j | jq -r ".${parent_name} | keys[${l}-1]")
  property_count=$(yq read playground.yml -j | jq -r ".${parent_name}.${sub_parent_name}[0] | keys | length")
  iterator=$(echo ${iterator_array[${l}-1]})
  echo -e "\tfor (( ${iterator}=${sub_parent_name}_count; ${iterator}>0; ${iterator}-- )); do" >> "../straps/${parent_name}/${parent_name}.sh"
  for (( m=property_count; m>0; m-- )); do
    property_name=$(yq read playground.yml -j | jq -r ".${parent_name}.${sub_parent_name}[0] | keys[${m}-1]")
    echo -e "\t\t${property_name}=\$(yq read \"\${1}\" -j | jq -r \".${parent_name}.${sub_parent_name}[\${i}-1].${property_name}\")" >> "../straps/${parent_name}/${parent_name}.sh"
    echo -e "\t\techo \"#do shit with \${${property_name}}\"" >> "../straps/${parent_name}/${parent_name}.sh"
  done
echo -e "\tdone" >> "../straps/${parent_name}/${parent_name}.sh"
  echo -e "\t" >> "../straps/${parent_name}/${parent_name}.sh"
done
echo -e "}\n" >> "../straps/${parent_name}/${parent_name}.sh"
echo -e "strapped_${parent_name}_after () {\n\treturn\n}" >> "../straps/${parent_name}/${parent_name}.sh"

# String containing the strap README template
readme="# ${parent_name}

| Attribute     | Value                                     |
|--------------:|-------------------------------------------|
| Namespace     | ${parent_name}                                      |
| Emoji         | An emoji that best describes your strap   |
| Description   | A description of your strap               |
| Dependencies  | ex: Git                                   |
| Compatability | ex: Unix, Mac OS                          |

## Configuration

\`\`\`yml
$(cat playground.yml)
\`\`\`"

# Write README file for the new strap
echo -e "[Strap Generator] writing sample documentation for ${parent_name} in ${parent_name}/README.md"
echo -e "${readme}" > "../straps/${parent_name}/README.md"
