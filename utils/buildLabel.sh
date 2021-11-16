#!/bin/zsh

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

downloadURL=${1?:"need to provide a download URL."}

# Note: this tool _very_ experimental and does not work in many cases
# That being said, it's a great place to start for building up the label in the Case-statement

# Usage
# ./buildLabel.sh <URL to download software>

# Mark: Functions

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
    
    if [ -n "$archiveDestinationName" ]; then
        downloadURL=$(curl -sf "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | awk -F '"' "/browser_download_url/ && /$archiveName\"/ { print \$4; exit }")
    else
        downloadURL=$(curl -sf "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | awk -F '"' "/browser_download_url/ && /$filetype\"/ { print \$4; exit }")
    fi

    echo "$downloadURL"
    return 0
}
versionFromGit() {
    # $1 git user name, $2 git repo name
    gitusername=${1?:"no git user name"}
    gitreponame=${2?:"no git repo name"}
        
    appNewVersion=$(curl --silent --fail "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | grep tag_name | cut -d '"' -f 4 | sed 's/[^0-9\.]//g')
    if [ -z "$appNewVersion" ]; then
        printlog "could not retrieve version number for $gitusername/$gitreponame"
        appNewVersion=""
    else
        echo "$appNewVersion"
        return 0
    fi
}

pkgInvestigation() {
    echo "Package investigation."
    teamID=$(spctl -a -vv -t install "$archiveName" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()' )
    if [[ -z $teamID ]]; then
        echo "Error verifying PKG: $archiveName"
        echo "No TeamID found."
        exit 4
    fi
    echo "Team ID found for PKG: $teamID"
    
    echo "For PKGs it's advised to find packageID for version checking, so extracting those"
    pkgutil --expand "$pkgPath" "$archiveName"_pkg
    if [[ -a "$archiveName"_pkg/Distribution ]] ; then
        cat "$archiveName"_pkg/Distribution | xpath '//installer-gui-script/pkg-ref[@id][@version]' 2>/dev/null
        packageID="$(cat "$archiveName"_pkg/Distribution | xpath '//installer-gui-script/pkg-ref[@id][@version]' 2>/dev/null | tr ' ' '\n' | grep -i "id" | cut -d \" -f 2)"
    elif [[ -a "$archiveName"_pkg/PackageInfo ]] ; then
        cat "$archiveName"_pkg/PackageInfo | xpath '//pkg-info/@version' 2>/dev/null
        packageID="$(cat "$archiveName"_pkg/PackageInfo | xpath '//pkg-info/@identifier' 2>/dev/null | cut -d '"' -f2 )"
    fi
    rm -r "$archiveName"_pkg
    echo "$packageID"
    echo "Above is the possible packageIDs that can be used, and the correct one is probably one of those with a version number. More investigation might be needed to figure out correct packageID if several are displayed."
}
appInvestigation() {
    appName=${appPath##*/}
    name=${appName%.*}
    echo "Application investigation."

    # verify with spctl
    teamID=$(spctl -a -vv "$appPath" 2>&1 | awk '/origin=/ {print $NF }'  | tr -d '()' )
    if [[ -z $teamID ]]; then
        echo "Error verifying app: $appPath"
        echo "No TeamID found."
        exit 4
    fi
    echo "Team ID found for app: $teamID"
}

# Mark: Code
# Use working directory as download folder
tmpDir="$(pwd)/$(date "+%Y-%m-%d-%H-%M-%S")"
# Create a n almost unique folder name
mkdir $tmpDir

# change directory to temporary working directory
echo "Changing directory to $tmpDir"
if ! cd "$tmpDir"; then
    echo "Error changing directory $tmpDir"
    exit 1
fi
echo "Working dir: $(pwd)"

# download the URL
echo "Downloading $downloadURL"
echo $(basename $downloadURL)
#exit
echo "Redirecting to (maybe this can help us with version):\n$(curl -fsIL -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -H "accept-encoding: gzip, deflate, br" -H "Referrer Policy: strict-origin-when-cross-origin" -H "upgrade-insecure-requests: 1" -H "sec-fetch-dest: document" -H "sec-gpc: 1" -H "sec-fetch-user: ?1" -H "accept-language: en-US,en;q=0.9" -H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9" -H "sec-fetch-mode: navigate" "$downloadURL" | grep -i "^[location|x\-amz\-meta\-version]*")"
if ! downloadOut="$(curl -fL "$downloadURL" --remote-header-name --remote-name -w "%{filename_effective}\n%{url_effective}\n")"; then
    echo "error downloading $downloadURL using standard headers."
    echo "result: $downloadOut"
    echo "Trying all headers…"
    if ! downloadOut="$(curl -fL -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -H "accept-encoding: gzip, deflate, br" -H "Referrer Policy: strict-origin-when-cross-origin" -H "upgrade-insecure-requests: 1" -H "sec-fetch-dest: document" -H "sec-gpc: 1" -H "sec-fetch-user: ?1" -H "accept-language: en-US,en;q=0.9" -H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9" -H "sec-fetch-mode: navigate" "$downloadURL" --remote-header-name --remote-name -w "%{filename_effective}\n%{url_effective}\n")"; then
        echo "error downloading $downloadURL using all headers."
        echo "result: $downloadOut"
        if [[ -n $downloadOut ]]; then
            echo "Trying output of this…"
            downloadURL="$(echo $downloadOut | tail -1)"
            if ! downloadOut="$(curl -fL "$downloadURL" --remote-header-name --remote-name -w "%{filename_effective}\n%{url_effective}\n")"; then
                echo "error downloading $downloadURL using previous output."
                echo "result: $downloadOut"
                echo "No more tries. Cannot continue."
                exit 1
            fi
        fi
    fi
fi

#echo "downloadOut:\n${downloadOut}"
archiveTempName=$( echo "${downloadOut}" | head -1 )
echo "archiveTempName: $archiveTempName"
archivePath=$( echo "${downloadOut}" | tail -1 )
echo "archivePath: $archivePath"

try1archiveName=${${archiveTempName##*/}%%\?*}
try2archiveName=${${archivePath##*/}%%\?*}
fileName_re='^([a-zA-Z0-9\_.%-]*)\.(dmg|pkg|zip|tbz)$'
if [[ "${try1archiveName}" =~ $fileName_re ]]; then
    archiveName=${try1archiveName}
elif [[ "${try2archiveName}" =~ $fileName_re ]]; then
    archiveName=${try2archiveName}
else
    echo "Could not determine archiveName from “$try1archiveName” and “$try2archiveName”"
    #echo "Extensions $archiveTempName:t:e $archivePath:t:e"
    exit
fi

echo "Calculated archiveName: $archiveName"
mv $archiveTempName $archiveName
name=${archiveName%.*}
echo "name: $name"
archiveExt=${archiveName##*.}
type=$archiveExt
echo "archiveExt: $archiveExt"
identifier=${name:l}
identifier=${identifier//\%[0-9a-fA-F][0-9a-fA-F]}
identifier=${identifier//[,._*@$\(\)\-]}
echo "identifier: $identifier"

if [ "$archiveExt" = "pkg" ]; then
    pkgPath="$archiveName"
    echo "PKG found: $pkgPath"
    pkgInvestigation
elif [ "$archiveExt" = "dmg" ]; then
    echo "Diskimage found"
    # mount the dmg
    echo "Mounting $archiveName"
    if ! dmgmount=$(echo "Y"$'\n' | hdiutil attach "$archiveName" -nobrowse -readonly | tail -n 1 | cut -c 54- ); then
        echo "Error mounting $archiveName"
        exit 3
    fi
    echo "Mounted: $dmgmount"
    
    # check if app og pkg exists
    appPath=$(find "$dmgmount" -name "*.app" -maxdepth 1 -print )
    pkgPath=$(find "$dmgmount" -name "*.pkg" -maxdepth 1 -print )
    
    if [[ $appPath != "" ]]; then
        echo "App found: $appPath"
        appInvestigation
    elif [[ $pkgPath != "" ]]; then
        echo "PKG found: $pkgPath"
        archiveExt="pkgInDmg"
        pkgInvestigation
    else
        echo "Nothing found on DMG."
        exit 9
    fi
    
    hdiutil detach "$dmgmount"
elif [ "$archiveExt" = "zip" ] || [ "$archiveExt" = "tbz" ]; then
    echo "Compressed file found"
    # unzip the archive
    tar -xf "$archiveName"
    
    # check if app og pkg exists
    appPath=$(find "$tmpDir" -name "*.app" -maxdepth 2 -print )
    pkgPath=$(find "$tmpDir" -name "*.pkg" -maxdepth 2 -print )
    
    if [[ $appPath != "" ]]; then
        echo "App found: $appPath"
        appInvestigation
    elif [[ $pkgPath != "" ]]; then
        echo "PKG found: $pkgPath"
        archiveExt="pkgInZip"
        pkgInvestigation
    else
        echo "Nothing found in compressed archive."
        exit 9
    fi

fi

if echo "$downloadURL" | grep -i "github.com.*releases/download"; then
    echo "\n**********\n\nFound GitHub path"
    githubAuthor=$(echo "$downloadURL" | cut -d "/" -f4)
    githubRepo=$(echo "$downloadURL" | cut -d "/" -f5)
    if [[ ! -z $githubAuthor && $githubRepo ]] ; then
        githubError=9
        echo "Github place: $githubAuthor $githubRepo"
        originalDownloadURL="$downloadURL"
        githubDownloadURL=$(downloadURLFromGit "$githubAuthor" "$githubRepo")
        githubAppNewVersion=$(versionFromGit "$githubAuthor" "$githubRepo")
        downloadURL=$originalDownloadURL
        echo "Latest URL on github: $githubDownloadURL \nLatest version: $githubAppNewVersion"
        if [[ "$originalDownloadURL" == "$githubDownloadURL" ]]; then
            echo "GitHub calculated URL matches entered URL."
            githubError=0
            downloadURL="\$(downloadURLFromGit $githubAuthor $githubRepo)"
            appNewVersion="\$(versionFromGit $githubAuthor $githubRepo)"
        else
            if [[ "$( echo $originalDownloadURL | cut -d "/" -f1-7)" == "$( echo $githubDownloadURL | cut -d "/" -f1-7)" ]]; then
                echo "Calculated GitHub URL almost identical, only this diff:"
                echo "“$( echo $originalDownloadURL | cut -d "/" -f8-)” and “$( echo $githubDownloadURL | cut -d "/" -f8-)”"
                echo "Could be version difference or difference in archiveName for a given release."
                echo "Testing for version difference."
                #Investigate if these strings match if numbers are removed.
                if [[ "$( echo $originalDownloadURL | cut -d "/" -f8- | sed 's/[0-9.]*//g')" == "$( echo $githubDownloadURL | cut -d "/" -f8- | sed 's/[0-9.]*//g')" ]]; then
                    echo "“$( echo $originalDownloadURL | cut -d "/" -f8- | sed 's/[0-9.]*//g')” and “$( echo $githubDownloadURL | cut -d "/" -f8- | sed 's/[0-9.]*//g')”"
                    echo "Matching without numbers in string.\nVERY LIKELY a version difference."
                    githubError=1
                    echo "Try running again with URL: ${githubDownloadURL}"
                else
                    echo "Not a version problem.\nTesting for difference in archiveName."
                    tempName=$(echo ${archiveName%.*} | grep -o "[0-9.]*")
                    archiveDestinationName="$(echo $archiveName | sed -E "s/^(.*)$tempName(.*)$/\1[0-9.]*\2/g")"
                    echo "archiveName=\"$archiveDestinationName\""
                    githubDownloadURL=$(downloadURLFromGit "$githubAuthor" "$githubRepo")
                    githubAppNewVersion=$(versionFromGit "$githubAuthor" "$githubRepo")
                    downloadURL=$originalDownloadURL
                    echo "Latest URL on github: $githubDownloadURL \nLatest version: $githubAppNewVersion"
                    if [[ "$originalDownloadURL" == "$githubDownloadURL" ]]; then
                        echo "GitHub calculated URL matches entered URL."
                        githubError=0
                        downloadURL="\$(downloadURLFromGit $githubAuthor $githubRepo)"
                        appNewVersion="\$(versionFromGit $githubAuthor $githubRepo)"
                    else
                        githubError=2
                        echo "Not solved by using archiveName."
                        echo "Not sure what this can be."
                        archiveDestinationName=""
                    fi
                fi
                #downloadURL="\$(downloadURLFromGit $githubAuthor $githubRepo)"
                #appNewVersion="\$(versionFromGit $githubAuthor $githubRepo)"
            else
                echo "GitHub URL not matching"
            fi
        fi
    fi
fi

echo "\n**********"
echo "\nLabels should be named in small caps, numbers 0-9, “-”, and “_”. No other characters allowed."

if [[ -z $githubError || $githubError != 0 ]]; then
echo "\nappNewVersion is often difficult to find. Can sometimes be found in the filename, sometimes as part of the download redirects, but also on a web page. See redirect and archivePath above if link contains information about this. That is a good place to start"
fi

echo "\n$identifier)"
echo "    name=\"$name\""
echo "    type=\"$archiveExt\""
if [ -n "$packageID" ]; then
echo "    packageID=\"$packageID\""
fi
if [ -n "$archiveDestinationName" ]; then
echo "    archiveName=\"$archiveDestinationName\""
fi
echo "    downloadURL=\"$downloadURL\""
echo "    appNewVersion=\"$appNewVersion\""
echo "    expectedTeamID=\"$teamID\""
if [ -n "$appName" ] && [ "$appName" != "${name}.app" ]; then
echo "    appName=\"$appName\""
fi
echo "    ;;"

case $githubError in
0)
    echo "\nLabel converted to GitHub label without errors."
    echo "Details can be seen above."
    ;;
1)
    echo "\nFound Github place in this URL: $githubAuthor $githubRepo"
    echo "But version has a problem."
    echo "Try running again with URL: ${githubDownloadURL}"
    echo "See details above."
    ;;
2)
    echo "\nFound Github place in this URL: $githubAuthor $githubRepo"
    echo "But it could not be resolved."
    echo "Can be from a hidden repository."
    ;;
esac

echo "\nAbove should be saved in a file with exact same name as label, and given extension “.sh”."
echo "Put this file in folder “fragments/labels”.\n"
