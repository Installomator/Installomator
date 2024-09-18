#!/bin/zsh --no-rcs

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# Check Installomator with various labels in various modes
# 2022 Søren Theilgaard (@theilgaard)

# This script will use various labels to check if Installomator is working as it is supposed to do

# To check this script use these labels:
# desktoppr dbeaverce brave microsoftteams whatsapp citrixworkspace aircall devonthink


# MARK: Constants

# Labels to test in DEBUG=2 mode
allLabels=( dbeaverce signal malwarebytes mochatn3270 logitechoptions googlechrome brave macports inkscape devonthink omnidisksweeper microsoftteams applenyfonts sketch sqlpropostgres desktoppr marathon)

# Labels to test for real (script use sudo to ask for admin rights)
# Purpose is only toest things that are being skipped in DEBUG mode
allLabelsArg=(
"vlc"
"depnotify NOTIFY=all"
"brave NOTIFY=silent"
"dialog"
"handbrake SYSTEMOWNER=1"
)


## Testing for combinations of these
# Label types: dmg, pkg, zip, tbz, pkgInDmg, pkgInZip, appInDmgInZip
# Label fields: packageID, appNewVersion, versionKey, appCustomVersion(){}, archiveName, appName, pkgName

# dbeaverse: dmg without appNewVersion and does not have LSMinimumSystemVersion in Info.plist
# signal: dmg with appNewVersion
# malwarebytes: pkg with appNewVersion but not packageID
# mochatn3270: appInDmgInZip with curlOptions
# logitechoptions pkgInZip with pkgName but without packageID
# googlechrome: dmg with appNewVersion
# brave: dmg with appNewVersion from versionKey
# macports: with custom code for archiveName, and with appNewVersion and appCustomVersion
# inkscape: dmg with appCustomVersion
# devonthink: appInDmgInZip
# omnidisksweeper: with appNewVersion, and uses xpath
# microsoftteams: pkg with appNewVersion from packageID
# applenyfonts: pkgInDmg from Apple with packageID and no appNewVersion
# sketch: zip with appNewVersion
# sqlpropostgres: zip without appNewVersion
# desktoppr: pkg from github with packageID
# marathon: dmg from github with archiveName

# Label types not possible to test in DEBUG mode: updateronly
# Label fields not possible to test in DEBUG mode: targetDir, blockingProcesses, updateTool, updateToolRunAsCurrentUser, installerTool, CLIInstaller, CLIArguments

# Labels tested for real

# vlc: app-copy
# depnotify: pkg-install without appNewVersion
# brave: app-copy but with few extras
# dialog: pkg from GitHub
# handbrake: app-copy

# adobecreativeclouddesktop: dmg with appNewVersion and installerTool, CLIInstaller, CLIArguments

#setup some folders
script_dir=$(dirname ${0:A})
repo_dir=$(dirname $script_dir)
build_dir="$repo_dir/build"
destination_file="$build_dir/Installomator.sh"
fragments_dir="$repo_dir/fragments"
labels_dir="$fragments_dir/labels"

# MARK: Script
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Check minimal macOS requirement
if [[ $(sw_vers -buildVersion ) < "18" ]]; then
    echo "Installomator requires at least macOS 10.14 Mojave."
    exit 98
fi

echo "TESTING Installoamator"
echo "Version: $($repo_dir/assemble.sh version)"
echo "\nRemember to follow log in another terminal window (for the REAL tests):"
echo "tail -f /var/log/Installomator.log\n"

currentUser=$(stat -f "%Su" /dev/console)

warningLabels="" # variable for labels with warnings
errorLabels="" # variable for labels with errors
countWarning=0
countError=0

checkCmd_output() {
    #echo "$cmd_output"
    no_appNewVersion=$( echo "$cmd_output" | grep --binary-files=text -ic "Latest version not specified." )
    echo "No appNewVersion: $no_appNewVersion (1 for no)"
    latest_appNewVersion=$( echo "$cmd_output" | grep --binary-files=text -i "Latest version of " | sed -E 's/.* is ([0-9.]*),*.*$/\1/g' )
    echo "Latest version: $latest_appNewVersion"
    github_label=$( echo "$cmd_output" | grep --binary-files=text -ci "Downloading https://github.com" )
    echo "GitHub: $github_label (1 for true)"
    downloaded_version=$( echo "$cmd_output" | grep --binary-files=text -ioE "Downloaded (package.*version|version of.*is) [0-9.]*" | grep -v "is the same as installed" | sed -E 's/.* (is|version) ([0-9.]*).*/\2/g' )
    echo "Downloaded version: $downloaded_version"
    exit_status=$( echo "$cmd_output" | grep --binary-files=text exit | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' )
    echo "Exit: $exit_status"
    if [[ ${exit_status} -eq 0 ]] ; then
        if [[ $no_appNewVersion -eq 1 ]]; then
            echo "${GREEN}$label works fine, but no appNewVersion.${NC}"
        elif [[ $latest_appNewVersion == $downloaded_version && $github_label -eq 0 ]]; then
            echo "${GREEN}$label works fine, with version $latest_appNewVersion.${NC}"
        elif [[ $github_label -eq 1 ]]; then
            echo "${GREEN}$label works fine, with GitHub version $latest_appNewVersion.${NC}"
        elif [[ $downloaded_version == "" ]]; then
            echo "${GREEN}$label works fine, but downloaded version can not be checked without packageID.${NC}"
        elif [[ $latest_appNewVersion != $downloaded_version && $github_label -eq 0 ]]; then
            echo "${YELLOW}$label has version warning, with latest $latest_appNewVersion not matching downloaded $downloaded_version.${NC}"
            ((countWarning++))
            warningLabels+=( "$label" )
            echo "$cmd_output"
        else
            echo "${RED}$label NOT WORKING:${NC}"
            ((countError++))
            errorLabels+=( "$label" )
            echo "$cmd_output"
        fi
    else
        echo "${RED}$label FAILED with exit code ${exit_status}:${NC}"
        ((countError++))
        errorLabels+=( "$label" )
        echo "$cmd_output"
    fi
}

# Mark: First part in DEBUG=2 mode
for label in $allLabels; do
    label_name=$( $repo_dir/assemble.sh $label DEBUG=2 RETURN_LABEL_NAME=1 | tail -1 )
    if [[ "$label_name" == "#" ]]; then
        echo "${RED}Label $label does not exist. Skipping.${NC}"
    else
        echo "Label $label: $label_name"
        cmd_output=$( $repo_dir/assemble.sh $label DEBUG=2 INSTALL=force IGNORE_APP_STORE_APPS=yes BLOCKING_PROCESS_ACTION=ignore )
        #echo "$cmd_output"
        checkCmd_output
        echo
    fi
done

# Mark: Testing for real
echo "\nTesting for REAL:\n"

for labelArg in $allLabelsArg; do
    echo $labelArg
    label=$(echo $labelArg | cut -d" " -f1 )
    arg1=$(echo $labelArg | cut -d" " -f2 )
    arg2=$(echo $labelArg | cut -d" " -f3 )
    label_name=$( $repo_dir/assemble.sh $label DEBUG=2 RETURN_LABEL_NAME=1 | tail -1 )
    if [[ "$label_name" == "#" ]]; then
        echo "${RED}Label $label does not exist. Skipping.${NC}"
    else
        echo "Label $label: $label_name"
        cmd_output=$( sudo $repo_dir/assemble.sh $label $arg1 $arg2 DEBUG=0 LOGGING=DEBUG INSTALL=force BLOCKING_PROCESS_ACTION=quit )
        #echo "$cmd_output"
        argument_variables=$( echo "$cmd_output" | grep --binary-files=text -i "setting variable from argument" | sed -E 's/.*setting variable from argument (.*)$/\1/g')
        echo $argument_variables
        checkCmd_output
        echo
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
    echo "${YELLOW}${errorLabels}${NC}"
else
    echo "${GREEN}No errors detected!${NC}"
fi

echo "Done!"
