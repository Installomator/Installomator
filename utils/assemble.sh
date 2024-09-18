#!/bin/zsh --no-rcs

# settings

# package
pkgname="Installomator"
identifier="com.scriptingosx.${pkgname}"
install_location="/usr/local/Installomator/"
signature="Developer ID Installer: Armin Briegel (JME5BW3F3R)"

# notarization
dev_keychain_label="notary-scriptingosx"

# parse arguments

zparseopts -D -E -a opts r -run s -script p -pkg n -notarize h -help -labels+:=label_args l+:=label_args

if (( ${opts[(I)(-h|--help)]} )); then
  echo "usage: assemble.sh [--script|--pkg|--notarize] [-labels path/to/labels ...] [arguments...]"
  echo
  echo "builds and runs the installomator script from the fragements."
  echo "additional arguments are passed into the Installomator script for testing."
  exit
fi

# default setting
runScript=1

if (( ${opts[(I)(-s|--script)]} )); then
    runScript=0
    buildScript=1
fi

if (( ${opts[(I)(-p|--pkg)]} )); then
    runScript=0
    buildScript=1
    buildPkg=1
fi

if (( ${opts[(I)(-n|--notarize)]} )); then
    runScript=0
    buildScript=1
    buildPkg=1
    notarizePkg=1
fi

# -r/--run option overrides default setting
if (( ${opts[(I)(-r|--run)]} )); then
    runScript=1
fi



label_flags=( -l --labels )
# array subtraction to remove options text
label_paths=(${label_args:|label_flags})

#setup some folders
script_dir=$(dirname ${0:A})
repo_dir=$(dirname $script_dir)
build_dir="$repo_dir/build"
destination_file="$build_dir/Installomator.sh"
fragments_dir="$repo_dir/fragments"
labels_dir="$fragments_dir/labels"

# add default labels_dir to label_paths
label_paths+=$labels_dir

#echo "label_paths: $label_paths"

fragment_files=( header.sh version.sh functions.sh arguments.sh main.sh )

# check if fragment files exist (and are readable)
for fragment in $fragment_files; do
    if [[ ! -e $fragments_dir/$fragment ]]; then
        echo "# $fragments_dir/$fragment not found!"
        exit 1
    fi
done

if [[ ! -d $labels_dir ]]; then
    echo "# $labels_dir not found!"
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
        echo "# $lpath not a directory, skipping..."
    fi
done

# add the footer
cat "$fragments_dir/main.sh" >> $destination_file

# set the executable bit
chmod +x $destination_file

# run script with remaining arguments
if [[ $runScript -eq 1 ]]; then
    $destination_file "$@"
    exit_code=$?
fi

# copy the script to root of repo when flag is set
if [[ $buildScript -eq 1 ]]; then
    echo "# copying script to $repo_dir/Installomator.sh"
    cp $destination_file $repo_dir/Installomator.sh
    chmod 755 $repo_dir/Installomator.sh
    # also update Labels.txt
    $repo_dir/Installomator.sh | tail -n +2 > $repo_dir/Labels.txt
fi

# build a pkg when flag is set
if [[ buildPkg -eq 1 ]]; then
    echo "# building installer package"

    tmpfolder=$(mktemp -d)
    payloadfolder="${tmpfolder}/payload"

    # create a projectfolder with a payload folder
    if [[ ! -d "${payloadfolder}" ]]; then
        mkdir -p "${payloadfolder}"
    fi

    # copy the script file
    cp $repo_dir/Installomator.sh ${payloadfolder}
    chmod 755 ${payloadfolder}/Installomator.sh

    # set the DEBUG variable to 0
    sed -i '' -e 's/^DEBUG=1$/DEBUG=0/g' ${payloadfolder}/Installomator.sh

    # build the component package
    pkgpath="${script_dir}/${pkgname}.pkg"

    pkgbuild --root "${payloadfolder}" \
             --identifier "${identifier}" \
             --version "${version}" \
             --install-location "${install_location}" \
             "${pkgpath}"

    # build the product archive

    productpath="${repo_dir}/${pkgname}-${version}.pkg"

    productbuild --package "${pkgpath}" \
                 --version "${version}" \
                 --identifier "${identifier}" \
                 --sign "${signature}" \
                 "${productpath}"

    # clean up project folder
    rm -Rf "${projectfolder}"
    # clean the component pkgname
    rm "$pkgpath"
fi

# notarize when flag is set
if [[ $notarizePkg -eq 1 ]]; then
    # NOTE: notarytool requires Xcode 13

    # upload for notarization
    xcrun notarytool submit "$productpath" --keychain-profile "$dev_keychain_label" --wait

    # staple result
    echo "# Stapling $productpath"
    xcrun stapler staple "$productpath"
fi

exit $exit_code
