#!/bin/bash

files=("/etc/profile" "/etc/bash.bashrc" "/etc/skel/.bashrc")

replacement='PS1='\''$(es=$?; if [ $es != 0 ]; then echo "\\[\\033[01;31m\\]RC="$es" "; fi)\\[\\033[1;37m\\]\\[\\033[01;36m\\]\\t\\[\\033[1;37m\\]\\[\\033[01;34m\\] \\h\\[\\033[1;37m\\] \\[\\033[01;33m\\]\\w\\[\\033[1;37m\\] \\[\\033[01;0m\\]\\$ '\'''

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    while IFS= read -r line; do
      if [[ $line =~ ^[[:space:]]*PS1= && ! $line =~ ^[[:space:]]*#.*PS1= ]]; then
        indentation=$(echo "$line" | sed -n 's/^\([[:blank:]]*\).*/\1/p')
        sed -i "s|^${indentation}PS1=.*|$indentation$replacement|" "$file"
        break
      fi
    done < "$file"
  fi
done