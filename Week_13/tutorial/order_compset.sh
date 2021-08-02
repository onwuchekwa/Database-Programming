#!/usr/bin/bash

# Assign user and password
username="${1}"
password="${2}"
directory="${3}"

echo "User name:" ${username}
echo "Password: " ${password}
echo "Directory:" ${directory}

# Define an array.
declare -a cmd

# Assign elements to an array.
cmd[0]="order_comp.sql"
cmd[1]="order_subcomp.sql"
cmd[2]="check_order.sql"

# Call the array elements.
for i in ${cmd[*]}; do
  sqlplus -s ${username}/${password} @${directory}/${i} 2> /dev/null
done
