#!/bin/bash
parent_name=$(yq read playground.yml -j | jq -r "keys[0]")
parent_count=$(yq read playground.yml -j | jq -r ".${parent_name} | length")

#
echo -e "#!/bin/bash" > "${parent_name}.sh"
echo -e "strapped_${parent_name}_before () {\n\tif ! ${parent_name} -V > /dev/null; then echo \":${parent_name}: ${parent_name} is missing\" && exit; fi\n}\n" > "${parent_name}.sh"


#local variable generator
for (( i=parent_count; i>0; i-- )); do
    sub_parent_name=$(yq read playground.yml -j | jq -r ".${parent_name} | keys[${i}-1]")
    echo -e "\tlocal ${sub_parent_name}_count" >> ${parent_name}.sh
    property_count=$(yq read playground.yml -j | jq -r ".${parent_name}.${sub_parent_name}[] | keys | length")
    for (( j=property_count; j>0; j-- )); do
        property_name=$(yq read playground.yml -j | jq -r ".${parent_name}.${sub_parent_name}[0] | keys[${j}-1]")
        echo -e "\tlocal ${property_name}" >> ${parent_name}.sh
    done
    
done
echo -e "\t" >> ${parent_name}.sh
#count variable generator
for (( k=parent_count; k>0; k-- )); do
    sub_parent_name=$(yq read playground.yml -j | jq -r ".${parent_name} | keys[${k}-1]")
    echo -e "\t\$${sub_parent_name}=\$(yq read "\${1}" -j | jq -r \".${parent_name}.${sub_parent_name} | length\")" >> ${parent_name}.sh
done
echo -e "\t" >> ${parent_name}.sh
#for loop generator
for (( l=parent_count; l>0; l-- )); do
  sub_parent_name=$(yq read playground.yml -j | jq -r ".${parent_name} | keys[${l}-1]")
  property_count=$(yq read playground.yml -j | jq -r ".${parent_name}.${sub_parent_name}[] | keys | length")
  echo -e "\tfor (( i=${sub_parent_name}_count; i>0; i-- )); do" >> ${parent_name}.sh
  for (( m=property_count; m>0; m-- )); do
    property_name=$(yq read playground.yml -j | jq -r ".${parent_name}.${sub_parent_name}[0] | keys[${m}-1]")
    echo -e "\t\t\$${property_name}=\$(yq read "\${1}" -j | jq -r \"${parent_name}.${sub_parent_name}[\${i}-1].${property_name}\")" >> ${parent_name}.sh
    echo -e "\t\techo \"#do shit with ${property_name}\"" >> ${parent_name}.sh
  done
echo -e "\tdone" >> ${parent_name}.sh
  echo -e "\t" >> ${parent_name}.sh
done