#!/bin/zsh


#setup some folders
script_dir=$(dirname ${0:A})
repo_dir=$(dirname $script_dir)
build_dir="$repo_dir/build"
destination_file="$build_dir/Installomator.sh"
fragments_dir="$repo_dir/fragments"
labels_dir="$fragments_dir/labels"

fragment_files=( header.txt version.txt functions.txt arguments.txt main.txt )

# check if fragment files exist (and are readable)
for fragment in $fragment_files; do
    if [[ ! -e $fragments_dir/$fragment ]]; then
        echo "$fragments_dir/$fragment not found!"
        exit 1
    fi
done

if [[ ! -d $labels_dir ]]; then
    echo "$labels_dir not found!"
    exit 1
fi

# create $build_dir when necessary
mkdir -p $build_dir

# add the header
cat "$fragments_dir/header.txt" > $destination_file

# read the version.txt
version=$(cat "$fragments_dir/version.txt")
versiondate=$(date +%F)
echo "VERSION=\"$version\"" >> $destination_file
echo "VERSIONDATE=\"$versiondate\"" >> $destination_file
echo >> $destination_file

# add the functions.txt
cat "$fragments_dir/functions.txt" >> $destination_file

# add the arguments.txt
cat "$fragments_dir/arguments.txt" >> $destination_file

# all the labels
cat "$labels_dir"/*.txt >> $destination_file

# add the footer
cat "$fragments_dir/main.txt" >> $destination_file

# set the executable bit
chmod +x $destination_file

