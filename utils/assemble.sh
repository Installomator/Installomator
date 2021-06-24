#!/bin/zsh

# parse arguments

zparseopts -D -E -a opts s -script p -pkg n -notarize h -help -labels+:=label_args l+:=label_args

if (( ${opts[(I)(-h|--help)]} )); then
  echo "usage: assemble.sh [--script|--pkg|--notarize] [-labels path/to/labels ...] [arguments...]"
  echo 
  echo "builds and runs the installomator script from the fragements."
  echo "additional arguments are passed into the Installomator script for testing."
  exit
fi

if (( ${opts[(I)(-s|--script)]} )); then
    buildScript=1
fi

if (( ${opts[(I)(-p|--pkg)]} )); then
    buildScript=1
    buildPkg=1
fi

if (( ${opts[(I)(-n|--notarize)]} )); then
    buildScript=1
    buildPkg=1
    notarizePkg=1
fi

label_flags=( -l --labels )
# array substraction
label_paths=${label_args:|label_flags}

#setup some folders
script_dir=$(dirname ${0:A})
repo_dir=$(dirname $script_dir)
build_dir="$repo_dir/build"
destination_file="$build_dir/Installomator.sh"
fragments_dir="$repo_dir/fragments"
labels_dir="$fragments_dir/labels"

# add default labels_dir to label_paths
label_paths+=$labels_dir

fragment_files=( header.sh version.sh functions.sh arguments.sh main.sh )

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
cat "$fragments_dir/header.sh" > $destination_file

# read the version.txt
version=$(cat "$fragments_dir/version.sh")
versiondate=$(date +%F)
echo "VERSION=\"$version\"" >> $destination_file
echo "VERSIONDATE=\"$versiondate\"" >> $destination_file
echo >> $destination_file

# add the functions.txt
cat "$fragments_dir/functions.sh" >> $destination_file

# add the arguments.txt
cat "$fragments_dir/arguments.sh" >> $destination_file

# all the labels
for lpath in $label_paths; do
    if [[ -d $lpath ]]; then
        cat "$lpath"/*.sh >> $destination_file
    else
        echo "$lpath not a directory, skipping..."
    fi
done

# add the footer
cat "$fragments_dir/main.sh" >> $destination_file

# set the executable bit
chmod +x $destination_file

# run script with remaining arguments
$destination_file "$@"

# TODO: build copy the script to root of repo when flag is set

# TODO: build a pkg when flag is set

# TODO: notarize when flag is set


