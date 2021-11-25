#!/bin/zsh

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# Check Installomator labels from fragments
# 2021 Søren Theilgaard (@theilgaard)

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
    
    #githubPart="$gitusername/$gitreponame/releases/download"
    #echo "$githubPart"
    downloadURL="https://github.com/$gitusername/$gitreponame/releases/latest"
    echo "$downloadURL"
    return 0
}

versionFromGit() { # $1 git user name, $2 git repo name
    gitusername=${1?:"no git user name"}
    gitreponame=${2?:"no git repo name"}
    
    appNewVersion=$(curl --silent --fail "https://github.com/$gitusername/$gitreponame/releases/latest" | sed -E 's/.*tag\/(.*)\">.*/\1/g' | sed 's/[^0-9\.]//g')
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


# MARK: Script
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Labels with the $(arch) call for different versions for Intel and Apple Silicon should be listed here:
archLabels=( $(grep "\$(arch)" ${labels_dir}/* | awk '{print $1}' | sed -E 's/.*\/([a-z0-9\_-]*)\..*/\1/g'| uniq ) )
echo "${BLUE}Labels with \"\$(arch)\" call:${NC}\n${archLabels}\n"

if [[ $# -eq 0 ]]; then
    allLabels=( $(grep -h -E '^([a-z0-9\_-]*)(\)|\|\\)$' ${labels_dir}/*.sh | tr -d ')|\\' | sort) )
else
    allLabels=( ${=@} )
fi
echo "${BLUE}Total labels:${NC}\n${allLabels}\n"

secondRoundLabels="" # variable for labels with $(arch) call in them
countWarning=0
countError=0
for fixedArch in i386 arm64; do
echo "${BLUE}Architecture: $fixedArch${NC}"
echo

# Go through all labels
for label in $allLabels; do
    echo "########## $label"
    labelWarning=0; labelError=0; expectedExtension=""; URLextension=""
    name=""; type=""; downloadURL=""; appNewVersion=""; expectedTeamID=""; blockingProcesses=""; updateTool=""; updateToolArguments=""; archiveName=""
    
    #caseLabel
    if cat "${labels_dir}/${label}.sh" | grep -v -E '^[a-z0-9\_-]*(\)|\|\\)$' | grep -v ";;" > checkLabelCurrent.sh; then
        source checkLabelCurrent.sh

        echo "Name: $name"
        echo "Download URL: $downloadURL"
        echo "Type: $type"
        case $type in
            dmg|pkg|zip|tbz)
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
        if curl -sfL --output /dev/null -r 0-0 "$downloadURL" ; then
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
        if [[ $labelWarning != 0 ]]; then; echo "${YELLOW}########## Warning in label: $label${NC}"; ((countWarning++)); fi
        if [[ $labelError != 0 ]]; then; echo "${RED}########## ERROR in label: $label${NC}"; ((countError++)); fi

        if (($archLabels[(Ie)$label])); then
            secondRoundLabels+=( "$label" )
        fi
    else
        echo "Label: ${label} is not it's own file in Labels-folder. Skipping"
    fi
    echo
done
allLabels=( ${=secondRoundLabels} )
archLabels=()
echo
done

rm checkLabelCurrent.sh

#${SELFLOCATION}/Installomator.sh version
#echo

if [[ countWarning > 0 ]]; then
    echo "${YELLOW}Warnings counted: $countWarning${NC}"
else
    echo "${GREEN}No warnings detected!${NC}"
fi
if [[ countError > 0 ]]; then
    echo "${RED}ERRORS counted: $countError${NC}"
else
    echo "${GREEN}No errors detected!${NC}"
fi

echo "Done!"
