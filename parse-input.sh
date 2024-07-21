#!/bin/bash

# Check if the input file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <name-of-text-file>"
    exit 1
fi

INPUT_FILE=$1

# Check if the input file exists
if [ ! -f $INPUT_FILE ]; then
    echo "File $INPUT_FILE does not exist."
    exit 1
fi

# Read the input file and call the second script for each line
while IFS=';' read -r USERNAME GROUPS; do
    # Trim whitespace
    USERNAME=$(echo $USERNAME | xargs)
    GROUPS=$(echo $GROUPS | xargs)

    # Call the user creation script
    sudo ./create_users.sh "$USERNAME" "$GROUPS"
done < "$INPUT_FILE"
