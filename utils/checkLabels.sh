#!/bin/zsh --no-rcs

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# Check Installomator labels from fragments
# 2021-2022 Søren Theilgaard (@theilgaard)

# This script will test labels and check if download link is active, and if version is defined.
# If labels are written to the script only those will be tested.
# If none are provided, it will test all labels.

# Labels should be named in small caps, numbers 0-9, “-”, and “_”. No other characters allowed.

# To check this script use these labels:
# desktoppr dbeaverce brave microsoftteams whatsapp citrixworkspace aircall devonthink


# MARK: Constants

#setup some folders
script_dir=$(dirname ${0:A})
repo_dir=$(dirname $script_dir)
build_dir="$repo_dir/build"
destination_file="$build_dir/Installomator.sh"
fragments_dir="$repo_dir/fragments"
labels_dir="$fragments_dir/labels"

# MARK: Check minimal macOS requirement
if [[ $(sw_vers -buildVersion ) < "18" ]]; then
    echo "Installomator requires at least macOS 10.14 Mojave."
    exit 98
fi

currentUser=$(stat -f "%Su" /dev/console)


# MARK: Functions

printlog(){
    echo "$1"
}

runAsUser() {
    if [[ $currentUser != "loginwindow" ]]; then
        uid=$(id -u "$currentUser")
        launchctl asuser $uid sudo -u $currentUser "$@"
    fi
}

# will get the latest release download from a github repo
downloadURLFromGit() { # $1 git user name, $2 git repo name
    gitusername=${1?:"no git user name"}
    gitreponame=${2?:"no git repo name"}

    if [[ $type == "pkgInDmg" ]]; then
        filetype="dmg"
    elif [[ $type == "pkgInZip" ]]; then
        filetype="zip"
    else
        filetype=$type
    fi

    #githubPart="$gitusername/$gitreponame/releases/download"
    #echo "$githubPart"
    #downloadURL="https://github.com/$gitusername/$gitreponame/releases/latest"
    if [ -n "$archiveName" ]; then
        downloadURL=https://github.com$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*$archiveName" | head -1)
    else
        downloadURL=https://github.com$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)
    fi
    echo "$downloadURL"
    return 0
}

versionFromGit() { # $1 git user name, $2 git repo name
    gitusername=${1?:"no git user name"}
    gitreponame=${2?:"no git repo name"}

    appNewVersion=$(curl -sLI "https://github.com/$gitusername/$gitreponame/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed 's/[^0-9\.]//g')
    if [ -z "$appNewVersion" ]; then
        printlog "could not retrieve version number for $gitusername/$gitreponame: $appNewVersion"
        exit 9
    else
        echo "$appNewVersion"
        return 0
    fi
}


# Handling of differences in xpath between Catalina and Big Sur
xpath() {
    # the xpath tool changes in Big Sur and now requires the `-e` option
    if [[ $(sw_vers -buildVersion) > "20A" ]]; then
        /usr/bin/xpath -e $@
    else
        /usr/bin/xpath $@
    fi
}

# Handling architecture, so I can verify both i386 and arm64 architectures
arch () {
    echo $fixedArch
}

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

# MARK: Script
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Has label(s) been given as arguments or not, and list those
# Figure out which ones of these include "$(arch)" so those will be testet for both i386 and arm64 architectures
if [[ $# -eq 0 ]]; then
    allLabels=( $(grep -h -E '^([a-z0-9\_-]*)(\)|\|\\)$' ${labels_dir}/*.sh | tr -d ')|\\' | sort) )
    archLabels=( $(grep "\$(arch)" ${labels_dir}/* | awk '{print $1}' | sed -E 's/.*\/([a-z0-9\_-]*)\..*/\1/g'| uniq ) )
else
    allLabels=( ${=@} )
    # Check if labels exist
    for checkLabel in $allLabels; do
        if [ ! $(ls ${labels_dir}/${checkLabel}.sh 2>/dev/null) ] ; then
            # Remove label from array
            allLabels=("${(@)allLabels:#$checkLabel}")
        fi
    done
    # Figure out if labels has "$(arch)" in them
    archLabels=( $allLabels )
    for checkLabel in $archLabels; do
        if [ ! -n "$(grep "\$(arch)" ${labels_dir}/${checkLabel}.sh 2>/dev/null)" ] ; then
            # Remove label from array
            archLabels=("${(@)archLabels:#$checkLabel}")
        fi
    done
fi

echo "${BLUE}Total labels:${NC}\n${allLabels}\n"
echo "${BLUE}Labels with \"\$(arch)\" call:${NC}\n${archLabels}\n"

secondRoundLabels="" # variable for labels with $(arch) call in them
warningLabels="" # variable for labels with warnings
errorLabels="" # variable for labels with errors
countWarning=0
countError=0

# Loop through the 2 architectures
for fixedArch in i386 arm64; do
    echo "${BLUE}Architecture: $fixedArch${NC}"
    echo

    # Loop through all labels
    for label in $allLabels; do
        echo "########## $label"
        labelWarning=0; labelError=0; expectedExtension=""; URLextension=""
        name=""; type=""; downloadURL=""; curlOptions=""; appNewVersion=""; expectedTeamID=""; blockingProcesses=""; updateTool=""; updateToolArguments=""; archiveName=""

        #caseLabel
        if cat "${labels_dir}/${label}.sh" | grep -v -E '^[a-z0-9\_-]*(\)|\|\\)$' | grep -v ";;" > checkLabelCurrent.sh; then
            INSTALL=force # This is only to prevent various Microsoft labels from running "msupdate --list"
            source checkLabelCurrent.sh

            echo "Name: $name"
            echo "Download URL: $downloadURL"
            echo "Type: $type"
            case $type in
                dmg|pkg|zip|tbz|bz2)
                    expectedExtension="$type"
                    ;;
                pkgInDmg)
                    expectedExtension="dmg"
                    ;;
                *InZip)
                    expectedExtension="zip"
                    ;;
                *)
                    echo "Cannot handle type $type"
                    ;;
            esac
            if [[ "$appNewVersion" == "" ]] ; then
                echo "No appNewVersion!"
            else
                if [[ $( echo "$appNewVersion" | grep -i "[0-9.]" ) == "" || $appNewVersion == "" ]]; then
                    echo "${RED}-> !! ERROR in appNewVersion${NC}"
                    labelError=1
                else
                    if [[ $appNewVersion != $( echo "$appNewVersion" | sed -E 's/[^0-9]*([0-9.]*)[^0-9]*/\1/g' ) ]]; then
                        echo "${YELLOW}Warning: Version contain not only numbers and dots.${NC}"
                        labelWarning=1
                    fi
                    echo "Version: $appNewVersion" ;
                fi
            fi
            if curl -sfL ${curlOptions} --output /dev/null -r 0-0 "$downloadURL" ; then
                echo "${GREEN}OK: downloadURL works OK${NC}"
                if [[ $(echo "$downloadURL" | sed -E 's/.*\.([a-zA-Z]*)\s*/\1/g' ) == "${expectedExtension}" ]]; then
                    echo "${GREEN}OK: download extension MATCH on ${expectedExtension}${NC}"
                else
                    if [[ $(echo "$downloadURL" | grep -io "github.com") != "github.com" ]]; then
                        URLheader=$( curl -fsIL "$downloadURL" )
                        if [[ "${URLheader}" != "" ]]; then
                            URLlocation=$( echo "${URLheader}" | grep -i "^location" )
                            URLfilename=$( echo "${URLheader}" | grep -i "filename=" )
                            if [[ "${URLlocation}" != "" ]]; then
                                URLextension=$( echo "${URLlocation}" | tail -1 | sed -E 's/.*\.([a-zA-Z]*)\s*/\1/g' | tr -d '\r\n' )
                            else
                                URLextension=$( echo "${URLfilename}" | tail -1 | sed -E 's/.*\.([a-zA-Z]*)\s*/\1/g' | tr -d '\r\n' )
                            fi
                            URLextension=${${URLextension:l}%%\?*}
                            if [[ "${URLextension}" == "${expectedExtension}" ]]; then
                                echo "${GREEN}OK: download extension MATCH on ${URLextension}${NC}"
                            else
                                echo "${RED}-> !! ERROR in download extension, expected ${expectedExtension}, but got ${URLextension}.${NC}"
                                labelError=1
                            fi
                        else
                            echo "no header provided from server."
                        fi
                    else
                        githubPart="$(echo "$downloadURL" | cut -d "/" -f4-6)"
                        if [[ "$(curl -fsL "$downloadURL" | grep -io "${githubPart}.*\.${expectedExtension}")" != "" ]]; then
                            echo "${GREEN}OK: download extension MATCH on ${expectedExtension}${NC}"
                        else
                            echo "${RED}-> !! ERROR in download extension, expected ${expectedExtension}, but it was wrong${NC}"
                            labelError=1
                        fi
                    fi
                fi
            else
                echo "${RED}-> !! ERROR in downloadURL${NC}"
                labelError=1
            fi
            if [[ $labelError != 0 || $labelWarning != 0 ]]; then
                echo "${RED}########## ERROR in label: $label${NC}"
                    echo "Testing using Installomator"
                    #exit_status=$( . $repo_dir/assemble.sh $label DEBUG=2 INSTALL=force IGNORE_APP_STORE_APPS=yes BLOCKING_PROCESS_ACTION=ignore | grep exit | tail -1 | sed -E 's/.*exit code ([0-9]).*/\1/g' )
                    cmd_output=$( $repo_dir/assemble.sh $label DEBUG=2 INSTALL=force IGNORE_APP_STORE_APPS=yes BLOCKING_PROCESS_ACTION=ignore )
                    #echo "$cmd_output"
                    checkCmd_output
                fi
            if (($archLabels[(Ie)$label])); then
                secondRoundLabels+=( "$label" )
            fi
        else
            echo "Label: ${label} is not it's own file in Labels-folder. Skipping"
        fi
        echo
    done
    if [[ $fixedArch == i386 ]] ; then
        errorLabelsi386=( ${=errorLabels} )
    else
        errorLabelsarm64=( ${=errorLabels} )
    fi

    errorLabels=""
    allLabels=( ${=secondRoundLabels} )
    archLabels=()
    echo
done

rm checkLabelCurrent.sh

if [[ countWarning -gt 0 ]]; then
    echo "${YELLOW}Warnings counted: $countWarning${NC}"
    echo "${YELLOW}${warningLabels}${NC}"
else
    echo "${GREEN}No warnings detected!${NC}"
fi
if [[ countError -gt 0 ]]; then
    echo "${RED}ERRORS counted: $countError${NC}"
    echo "${RED}i386 : ${errorLabelsi386}${NC}"
    echo "${RED}arm64: ${errorLabelsarm64}${NC}"
else
    echo "${GREEN}No errors detected!${NC}"
fi

echo "Done!"
