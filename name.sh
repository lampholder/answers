#!/bin/bash

set -e

PLACEHOLDER="my project name"
REPLACEMENT=$1

if [ -z $REPLACEMENT ]; then
    echo "Usage:"
    echo "./"$(basename "$0") "\"new name\""
    exit 1
fi

PLACEHOLDER_DASHES=$(echo $PLACEHOLDER | sed 's/ /-/g')
PLACEHOLDER_UNDERSCORES=$(echo $PLACEHOLDER | sed 's/ /_/g')

REPLACEMENT_DASHES=$(echo $REPLACEMENT | sed 's/ /-/g')
REPLACEMENT_UNDERSCORES=$(echo $REPLACEMENT | sed 's/ /_/g')

echo "Renaming (git mv) files and directories:"
for file_or_directory in $(find . -depth -name "*$PLACEHOLDER_DASHES*"); do
    echo $file_or_directory
    renamed_file_or_directory=$(echo $file_or_directory | sed -E "s/(.*)$PLACEHOLDER_DASHES/\1$REPLACEMENT_DASHES/g")
    if [[ $file_or_directory != $renamed_file_or_directory ]]; then
        #git mv $file_or_directory $renamed_file_or_directory
        echo " - $file_or_directory -> $renamed_file_or_directory"
    fi
done
for file_or_directory in $(find . -depth -name "*$PLACEHOLDER_UNDERSCORES*"); do
    echo $file_or_directory
    renamed_file_or_directory=$(echo $file_or_directory | sed -E "s/(.*)$PLACEHOLDER_UNDERSCORES/\1$REPLACEMENT_UNDERSCORES/g")
    if [[ $file_or_directory != $renamed_file_or_directory ]]; then
        #git mv $file_or_directory $renamed_file_or_directory
        echo " - $file_or_directory -> $renamed_file_or_directory"
    fi
done

echo "Updating references within files:"
for file in $(grep -lEw "$PLACEHOLDER_DASHES|$PLACEHOLDER_UNDERSCORES)" -R *); do
    if [[ $file != $(basename "$0") ]]; then
        sed -i '' "s/$PLACEHOLDER_DASHES/$REPLACEMENT_DASHES/g" $file
        sed -i '' "s/$PLACEHOLDER_UNDERSCORES/$REPLACEMENT_UNDERSCORES/g" $file
        echo " - $file"
    fi
done

echo "DONE"
