#!/bin/bash

# Use case: Multiple directories containing the same set of files, e.g. 1_org_zoom.jpg, 2_org_zoom.jpg, 3_org_zoom.jpg etc.
# We want to copy all the files into a single target directory, but renamed in such a way that they contain original folder name.
# This script goes through all subdirectories, and from each of them copies all files to target directory, under new name.
# Original directory name is taken ($d) without the last character (/), and then a counter is added
# Final copy command is run interactively (-i), so that overwrites need to be confirmed if they occur

for d in */ ; do
    echo "Entering $d"
    cd "$d"
    i=1
    for f in * ; do
        newname=$(basename $d)_$i.jpg
        # use newname=$(basename $d)_$i.${f##*.} to keep original file extension
        cp -iv "$f" "/home/mirko/Downloads/Test/$newname"
        ((i++))
    done
    cd ..
done

