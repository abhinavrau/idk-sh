#!/bin/bash
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

chmod +x "$TMP_FILE"
# Read the command to be run
command=$(< "$TMP_FILE")



if [ -z "$gumInstalled" ]; then  
    echo "$command"
    history -s "$command"
else   
    gum style --foreground "#04b575" --border-foreground 212 --border double --align center --width 50 --margin "1 2" --padding "2 4"  "$command"
    gum confirm "Run it?" && "$TMP_FILE" && history -s "$command"
fi


rm "$TMP_FILE"





