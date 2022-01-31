#!/bin/zsh

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# Check Installomator with various labels in various modes
# 2022 Søren Theilgaard (@theilgaard)

# This script will use various labels to check if Installomator is working as it is supposed to do

# To check this script use these labels:
# desktoppr dbeaverce brave microsoftteams whatsapp citrixworkspace aircall devonthink


# MARK: Constants
allLabels=( dbeaverce signal brave inkscape devonthink microsoftteams applenyfonts sketch sqlpropostgres desktoppr marathon)

# dbeaverse: dmg without appNewVersion
# signal: dmg with appNewVersion
# brave: dmg with appNewVersion from versionKey
# inkscape: dmg with appCustomVersion
# adobecreativeclouddesktop: dmg with appNewVersion and installerTool
# devonthink: appInDmgInZip
# microsoftteams: pkg with appNewVersion from packageID
# applenyfonts: pkgInDmg from Apple with packageID and no appNewVersion
# sketch: zip with appNewVersion
# sqlpropostgres: zip without appNewVersion
# desktoppr: pkg from github with packageID
# marathon: dmg from github with archiveName


#setup some folders
script_dir=$(dirname ${0:A})
repo_dir=$(dirname $script_dir)
build_dir="$repo_dir/build"
destination_file="$build_dir/Installomator.sh"
fragments_dir="$repo_dir/fragments"
labels_dir="$fragments_dir/labels"

# MARK: Script
# Check minimal macOS requirement
if [[ $(sw_vers -buildVersion ) < "18" ]]; then
    echo "Installomator requires at least macOS 10.14 Mojave."
    exit 98
fi

currentUser=$(stat -f "%Su" /dev/console)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color
countWarning=0
countError=0

for label in $allLabels; do
    cmd_output=$( $repo_dir/assemble.sh $label DEBUG=2 INSTALL=force IGNORE_APP_STORE_APPS=yes BLOCKING_PROCESS_ACTION=ignore )
    #echo "$cmd_output"
    no_appNewVersion=$( echo $cmd_output | grep -ic "Latest version not specified." )
    echo "No appNewVersion: $no_appNewVersion (1 for no)"
    latest_appNewVersion=$( echo $cmd_output | grep -i "Latest version of " | sed -E 's/.* is ([0-9.]*),*.*$/\1/g' )
    echo "Latest vesion: $latest_appNewVersion"
    github_label=$( echo $cmd_output | grep -ci "Downloading https://github.com" )
    echo "github: $github_label (1 for true)"
    downloaded_version=$( echo $cmd_output | grep -ioE "Downloaded (package.*version|version of.*is) [0-9.]*" | grep -v "is the same as installed" | sed -E 's/.* (is|version) ([0-9.]*).*/\2/g' )
    echo "Downloaded version: $downloaded_version"
    exit_status=$( echo $cmd_output | grep exit | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' )
    echo "Exit: $exit_status"
    if [[ ${exit_status} -eq 0 ]] ; then
        if [[ $no_appNewVersion -eq 1 ]]; then
            echo "${GREEN}$label works fine, but no appNewVersion.${NC}"
        elif [[ $latest_appNewVersion == $downloaded_version && $github_label -eq 0 ]]; then
            echo "${GREEN}$label works fine, with version $latest_appNewVersion.${NC}"
        elif [[ $github_label -eq 1 ]]; then
            echo "${GREEN}$label works fine, with GitHub version $latest_appNewVersion.${NC}"
        elif [[ $latest_appNewVersion != $downloaded_version && $github_label -eq 0 ]]; then
            echo "${YELLOW}$label has version warning, with latest $latest_appNewVersion not matching downloaded $downloaded_version.${NC}"
            ((countWarning++))
            echo "$cmd_output"
        else
            echo "${RED}$label NOT WORKING:${NC}"
            ((countError++))
            errorLabels+=( "$label" )
            echo "$cmd_output"
        fi
    else
        echo "${RED}$label NOT WORKING:${NC}"
        ((countError++))
        errorLabels+=( "$label" )
        echo "$cmd_output"
    fi
done

echo
if [[ countWarning -gt 0 ]]; then
    echo "${YELLOW}Warnings counted: $countWarning${NC}"
    echo "${YELLOW}${warningLabels}${NC}"
else
    echo "${GREEN}No warnings detected!${NC}"
fi
if [[ countError -gt 0 ]]; then
    echo "${RED}ERRORS counted: $countError${NC}"
else
    echo "${GREEN}No errors detected!${NC}"
fi

echo "Done!"
