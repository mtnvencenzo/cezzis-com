#!/bin/bash

# Recreate config file
rm -rf ./public/env-config.js
touch ./public/env-config.js

# Add assignment 
echo "window.windowEnv = {" >> ./public/env-config.js

# Read each line in .env file
# Each line represents key=value pairs
while read -r line || [[ -n "$line" ]];
do
  # Split env variables by character `=`
  if printf '%s\r\n' "$line" | grep -q -e '='; then
    varname=$(printf '%s\r\n' "$line" | sed -e 's/=.*//')
    varvalue=$(printf '%s\r\n' "$line" | sed -e 's/^[^=]*=//')
  fi

  # Read value of current variable if exists as Environment variable
  value=$(printf '%s\n' "${!varname}")
  # Otherwise use value from .env file
  [[ -z $value ]] && value=${varvalue}
  
  # Append configuration property to JS file
  echo "  $varname: \"$value\"," >> ./public/env-config.js
done < $1

echo "}" >> ./public/env-config.js


cp ./public/env-config.js ./env-config.js
