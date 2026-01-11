#!/bin/bash

# read json from stdin
eval "$(jq -r '@sh "HOST=\(.host) USER=\(.user) STORAGE=\(.storage) NODE=\(.node) PERCENTAGE=\(.percentage)"')"

#  use lvs
if [ -z "$FREE_SPACE" ] || [ "$FREE_SPACE" -eq 0 ]; then
  FREE_SPACE=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${USER}@${HOST}" \
    "lvs --noheadings --units g -o lv_size,lv_name | grep data | awk '{print \$1}' | sed 's/g//i' | awk '{print int(\$1)}'")
fi

# Compute Size to Allocate
SIZE_TO_ALLOCATE=$(echo "$FREE_SPACE * $PERCENTAGE / 100" | bc | awk '{print int($1)}')

# Minimum 10GB in case of error
if [ "$SIZE_TO_ALLOCATE" -lt 10 ]; then
  SIZE_TO_ALLOCATE=10
fi

# return as JSON
jq -n \
  --arg size "$SIZE_TO_ALLOCATE" \
  --arg free "$FREE_SPACE" \
  '{"size": $size, "free": $free}'