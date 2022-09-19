#!/bin/sh

# Addigy condition
# These are my notes for how I can extract all the label lines from Installomator.sh, evaluate those, and check if installed version is the latest version.
# This script contains functions from Installomator.
label="googlechromepkg"

# PATH declaration
export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# Functions from Installomator
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

    if [ -n "$archiveName" ]; then
        downloadURL=https://github.com$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*$archiveName" | head -1)
        if [[ "$(echo $downloadURL | grep -ioE "https.*$archiveName")" == "" ]]; then
            printlog "Trying GitHub API for download URL."
            downloadURL=$(curl -sfL "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | awk -F '"' "/browser_download_url/ && /$archiveName\"/ { print \$4; exit }")
        fi
    else
        downloadURL=https://github.com$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)
        if [[ "$(echo $downloadURL | grep -ioE "https.*.$filetype")" == "" ]]; then
            printlog "Trying GitHub API for download URL."
            downloadURL=$(curl -sfL "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | awk -F '"' "/browser_download_url/ && /$filetype\"/ { print \$4; exit }")
        fi
    fi
    if [ -z "$downloadURL" ]; then
        cleanupAndExit 14 "could not retrieve download URL for $gitusername/$gitreponame" ERROR
    else
        echo "$downloadURL"
        return 0
    fi
}

versionFromGit() {
    # credit: Søren Theilgaard (@theilgaard)
    # $1 git user name, $2 git repo name
    gitusername=${1?:"no git user name"}
    gitreponame=${2?:"no git repo name"}

    #appNewVersion=$(curl -L --silent --fail "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | grep tag_name | cut -d '"' -f 4 | sed 's/[^0-9\.]//g')
    appNewVersion=$(curl -sLI "https://github.com/$gitusername/$gitreponame/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed 's/[^0-9\.]//g')
    if [ -z "$appNewVersion" ]; then
        printlog "could not retrieve version number for $gitusername/$gitreponame" WARN
        appNewVersion=""
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
        # alternative: switch to xmllint (which is not perl)
        #xmllint --xpath $@ -
    else
        /usr/bin/xpath $@
    fi
}

# from @Pico: https://macadmins.slack.com/archives/CGXNNJXJ9/p1652222365989229?thread_ts=1651786411.413349&cid=CGXNNJXJ9
getJSONValue() {
    # $1: JSON string OR file path to parse (tested to work with up to 1GB string and 2GB file).
    # $2: JSON key path to look up (using dot or bracket notation).
    printf '%s' "$1" | /usr/bin/osascript -l 'JavaScript' \
        -e "let json = $.NSString.alloc.initWithDataEncoding($.NSFileHandle.fileHandleWithStandardInput.readDataToEndOfFile$(/usr/bin/uname -r | /usr/bin/awk -F '.' '($1 > 18) { print "AndReturnError(ObjC.wrap())" }'), $.NSUTF8StringEncoding)" \
        -e 'if ($.NSFileManager.defaultManager.fileExistsAtPath(json)) json = $.NSString.stringWithContentsOfFileEncodingError(json, $.NSUTF8StringEncoding, ObjC.wrap())' \
        -e "const value = JSON.parse(json.js)$([ -n "${2%%[.[]*}" ] && echo '.')$2" \
        -e 'if (typeof value === "object") { JSON.stringify(value, null, 4) } else { value }'
}

# Mark: Script
labelScript=$(grep -E -m 1 -A 30 "^$label"'(\)|\|\\)$' "/usr/local/Installomator/Installomator.sh" | grep -B 30 -m 1 ";;")
echo $labelScript
eval $labelScript
echo $appNewVersion



##############################
printLines=0; while read line; do; if [[ $printLines -eq 1 || "$(echo $line | grep -oE "^googlechromepkg")" != "" ]]; then; printLines=1; echo $line; fi; done < "/usr/local/Installomator/Installomator.sh"

printLines=0; while read line; do; if [[ $printLines -eq 1 ]]; then; if [[ "$(echo $line | grep ";;")" == "" ]]; then; echo $line; else; printLines=0; fi ; elif [[ "$(echo $line | grep -oE "^googlechromepkg")" != "" ]]; then; printLines=1; fi; done < "/usr/local/Installomator/Installomator.sh"

labelLines="$(printLines=0; while read line; do; if [[ $printLines -eq 1 ]]; then; if [[ "$(echo $line | grep ";;")" == "" ]]; then; echo $line; else; return; fi ; elif [[ "$(echo $line | grep -oE "^googlechromepkg")" != "" ]]; then; printLines=1; fi; done < "/usr/local/Installomator/Installomator.sh")"; echo $labelLines

label="googlechromepkg";labelLines="$(printLines=0; while read line; do; if [[ $printLines -eq 1 ]]; then; if [[ "$(echo $line | grep ";;")" == "" ]]; then; echo $line; else; return; fi ; elif [[ "$(echo $line | grep -oE "^$label")" != "" ]]; then; printLines=1; fi; done < "/usr/local/Installomator/Installomator.sh")"; eval $labelLines ; echo $appNewVersion


label="googlechromepkg"
labelLines="$(printLines=0
while read line; do
    if [[ $printLines -eq 1 ]]; then
        if [[ "$(echo $label | grep ";;")" == "" ]]; then
            echo $line
        else
            return
        fi
    elif [[ "$(echo $line | grep -oE "^$label")" != "" ]]; then
        printLines=1
    fi
done < "/usr/local/Installomator/Installomator.sh")"
eval $labelLines
echo $appNewVersion






