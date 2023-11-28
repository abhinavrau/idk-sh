#!/bin/zsh

if [[ $ZSH_EVAL_CONTEXT != 'toplevel:file' ]]; then
    echo "Error: Source the script instead of executing it:"
    echo
    echo "source $0"
    return 1 2>/dev/null || exit 1
fi

DIR="$(dirname -- "$0")"

TMP_FILE=$(mktemp)

# See if gum is installed
gumInstalled=$(which gum)

# Execute the wish script
if [ -z "$gumInstalled" ]; then  
    gum spin --spinner globe --title "Generating..." --show-output -- "$DIR/idk" "$@" > "$TMP_FILE"
else 
    "$DIR/idk" "$@" > "$TMP_FILE"
fi

# Read the command to be placed on the Zsh command line
commandToPlace=$(< "$TMP_FILE")

# Remove the temp file
rm "$TMP_FILE"

# Place it on the Zsh command line
print -rz "$commandToPlace"

# Add to history as well.
print -s "$commandToPlace"



