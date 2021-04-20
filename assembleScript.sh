#!/bin/zsh

destination_file="Installomator_assembled.sh"
fragments_dir="fragments"
labels_dir="$fragments_dir/labels"

# read the header
cat "$fragments_dir/header.txt" > $destination_file

# all the labels
cat "$labels_dir"/*.txt >> $destination_file

# add the footer
cat "$fragments_dir/footer.txt" >> $destination_file
