#!/bin/bash
source ./build/helpers.sh 

url_regex='^(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'

if [ ! -f "${1}" ]; then pretty_print "🔫" "You must pass a YML file to parse!" && exit 2; fi
if [[ "${1}" =~ $url_regex ]]; then 
  json=$(curl -s "${1}" | yq r - -j); 
else 
  json=$(yq r "${1}" -j); 
fi
if [ ! "${json}" ]; then pretty_print "🔫" "File appears empty" && exit 2; fi
    
parent_name=$(jq -r "keys[0]"  <<< "${json}")
parent_count=$(jq -r ".${parent_name} | length" <<< "${json}")
iterator_array=(i j k l m n o p q r s t u v w x y z)

# Make doc/straps folder if it doesn't exist
pretty_print "🔫" "creating strap for ${parent_name} in _gen/${parent_name}"
mkdir -p "_gen/"
mkdir -p "_gen/${parent_name}"

pretty_print "🔫" "compiling strap"
overwrite_file "#!/bin/bash" "_gen/${parent_name}/${parent_name}.sh"
update_file "strapped_${parent_name}_before () {\\n\\tif ! ${parent_name} -V > /dev/null; then echo \":${parent_name}: ${parent_name} is missing\" && exit; fi\\n}\\n" "_gen/${parent_name}/${parent_name}.sh"

update_file "strapped_${parent_name} () {" "_gen/${parent_name}/${parent_name}.sh"

#local variable generator
for (( i=0; i < parent_count; i++ )); do
    sub_parent_name=$(jq -r ".${parent_name} | keys[${i}]" <<< "${json}")
    update_file "\\n\\tlocal ${sub_parent_name}_count" "_gen/${parent_name}/${parent_name}.sh"
    property_count=$(jq -r ".${parent_name}.${sub_parent_name}[0] | keys | length" <<< "${json}")
    for (( j=0; j<property_count; j++ )); do
        property_name=$(jq -r ".${parent_name}.${sub_parent_name}[0] | keys[${j}]" <<< "${json}")
        update_file "\\tlocal ${property_name}" "_gen/${parent_name}/${parent_name}.sh"
    done
    
done
#json variable generator
update_file "\\tlocal user_config \\n\\n \\tuser_config=\${1}" "_gen/${parent_name}/${parent_name}.sh"

#count variable generator
for (( k=0; k < parent_count; k++ )); do
    sub_parent_name=$(jq -r ".${parent_name} | keys[${k}]" <<< "${json}")
    update_file "\\t${sub_parent_name}_count=\$(q_count \"\${user_config}\" \"${sub_parent_name}\")\\n" "_gen/${parent_name}/${parent_name}.sh"
done

#for loop generator
for (( l=0; l < parent_count; l++ )); do
  sub_parent_name=$(jq -r ".${parent_name} | keys[${l}]" <<< "${json}")
  property_count=$(jq -r ".${parent_name}.${sub_parent_name}[0] | keys | length" <<< "${json}")
  iterator="${iterator_array[${l}]}"
  update_file "\\tfor (( ${iterator}=0; ${iterator} < ${sub_parent_name}_count; ${iterator}++ )); do" "_gen/${parent_name}/${parent_name}.sh"
  for (( m=0; m < property_count; m++ )); do
    property_name=$(jq -r ".${parent_name}.${sub_parent_name}[0] | keys[${m}]" <<< "${json}")
    update_file "\\t\\t${property_name}=\$(q \"\${user_config}\" \"${sub_parent_name}.\\\\\[\${${iterator}}\\\\\].${property_name}\")" "_gen/${parent_name}/${parent_name}.sh"
    update_file "\\t\\techo \"#do a thing with \${${property_name}}\"" "_gen/${parent_name}/${parent_name}.sh"
  done
  update_file "\\tdone\\t" "_gen/${parent_name}/${parent_name}.sh"
done
update_file "}\\n" "_gen/${parent_name}/${parent_name}.sh"
update_file "strapped_${parent_name}_after () {\\n\\treturn\\n}" "_gen/${parent_name}/${parent_name}.sh"

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
pretty_print "🔫" "gererating docs"
overwrite_file "${readme}" "_gen/${parent_name}/README.md"
pretty_print "🔫" "Success!"