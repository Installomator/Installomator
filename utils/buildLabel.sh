#!/bin/zsh --no-rcs

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
    teamID=$(spctl -a -vv -t install "$pkgPath" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()' )
    if [[ -z $teamID ]]; then
        echo "Error verifying PKG: $pkgPath"
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

dmgInvestigation() {
    echo "DMG investigation."
    # mount the dmg
    echo "Mounting $archiveName"
    if ! dmgmount=$(echo "Y"$'\n' | hdiutil attach "$archiveName" -nobrowse -readonly | tail -n 1 | cut -c 54- ); then
        echo "Error mounting $archiveName"
        exit 3
    fi
    echo "Mounted: $dmgmount"

    # check if app og pkg exists on disk image
    appPath=$(find "$dmgmount" -name "*.app" -maxdepth 1 -print )
    pkgPath=$(find "$dmgmount" -name "*.pkg" -maxdepth 1 -print )

    if [[ $appPath != "" ]]; then
        echo "App found: $appPath"
        if [[ $archiveExt = "dmgInZip" ]]; then
            archiveExt="appInDmgInZip"
        fi
        appInvestigation
    elif [[ $pkgPath != "" ]]; then
        echo "PKG found: $pkgPath"
        if [[ $archiveExt = "dmgInZip" ]]; then
            archiveExt="pkgInDmgInZip not supported, yet!"
        else
            archiveExt="pkgInDmg"
        fi
        pkgInvestigation
    else
        echo "Nothing found on DMG."
        exit 9
    fi

    hdiutil detach "$dmgmount"
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

# investigate and download the URL
echo "Downloading $downloadURL"
echo $(basename $downloadURL)
# First trying to find redirection headers on the download, as those can contain version numbers
echo "Redirecting to (maybe this can help us with version):\n$(curl -fsIL -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -H "accept-encoding: gzip, deflate, br" -H "Referrer Policy: strict-origin-when-cross-origin" -H "upgrade-insecure-requests: 1" -H "sec-fetch-dest: document" -H "sec-gpc: 1" -H "sec-fetch-user: ?1" -H "accept-language: en-US,en;q=0.9" -H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9" -H "sec-fetch-mode: navigate" "$downloadURL" | grep -i "^[location|x\-amz\-meta\-version]*")"
# Now downloading without various sets of extra headers
if ! downloadOut1="$( \
curl -fL "$downloadURL" --remote-header-name --remote-name \
-w "%{filename_effective}\n%{url_effective}\n")"
then
    echo "error downloading $downloadURL with no headers."
    echo "result: $downloadOut1"
    echo "Trying 1st set of extra headers to download."
    if ! downloadOut2="$( \
    curl -fL \
    -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" \
    -H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9" \
    -H "accept-encoding: gzip, deflate, br" \
    -H "accept-language: en-US,en;q=0.9" \
    -H "sec-fetch-dest: document" \
    -H "sec-fetch-mode: navigate" \
    -H "sec-fetch-user: ?1" \
    -H "sec-gpc: 1" \
    -H "upgrade-insecure-requests: 1" \
    "$downloadURL" --remote-header-name --remote-name \
    -w "%{filename_effective}\n%{url_effective}\n")"
    then
        echo "error downloading $downloadURL with 1st set of headers."
        echo "result: $downloadOut2"
        echo "Trying 2nd set of extra headers to download."
        if ! downloadOut3="$( \
        curl -fL \
        -H "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36" \
        -H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9" \
        -H "accept-encoding: gzip, deflate, br" \
        -H "accept-language: en-US,en;q=0.9" \
        -H "sec-fetch-dest: document" \
        -H "sec-fetch-mode: navigate" \
        -H "sec-fetch-site: same-site" \
        -H "sec-fetch-user: ?1" \
        -H "sec-gpc: 1" \
        -H "upgrade-insecure-requests: 1" \
        "$downloadURL" --remote-header-name --remote-name \
        -w "%{filename_effective}\n%{url_effective}\n")"
        then
            echo "error downloading $downloadURL with 2nd set of headers."
            echo "result: $downloadOut3"
            echo "Trying 3rd set of extra headers to download."
            if ! downloadOut4="$( \
            curl -fL \
            -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" \
            -H "accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9" \
            -H "accept-encoding: gzip, deflate, br" \
            -H "accept-language: en-US,en;q=0.9" \
            -H "sec-fetch-dest: document" \
            -H "sec-fetch-mode: navigate" \
            -H "sec-fetch-user: ?1" \
            -H "sec-gpc: 1" \
            -H "upgrade-insecure-requests: 1" \
            -H "Referrer Policy: strict-origin-when-cross-origin" \
            "$downloadURL" --remote-header-name --remote-name \
            -w "%{filename_effective}\n%{url_effective}\n")"
            then
                # we are only here if the download failed
                echo "error downloading $downloadURL with 3rd set of headers."
                echo "result: $downloadOut4"
                echo "no more header sets to try"
                # Sometimes a server will give some results to the downloaded output
                echo "If any information came out of the previous download attempts, we can try those…"
                downloadOuts=( "$downloadOut1" "$downloadOut3" "$downloadOut3" "$downloadOut4" )
                downloadOutCount=${#downloadOuts}
                for downloadOut in $downloadOuts ; do
                    if [[ -n $downloadOut ]]; then
                        echo "Trying output of this…"
                        downloadURL="$(echo $downloadOut | tail -1)"
                        # Last chance for succes on this download
                        if ! downloadOut="$(curl -fL "$downloadURL" --remote-header-name --remote-name -w "%{filename_effective}\n%{url_effective}\n")"; then
                            echo "error downloading $downloadURL using previous output."
                            echo "result: $downloadOut"
                            ((downloadOutCount--))
                        else
                            echo "Success on this download."
                            succesDownloadOut=$downloadOut
                            break 2
                        fi
                    fi
                done
                if [[ $downloadOutCount -eq 0 ]]; then
                    echo "No more tries. Cannot continue."
                    exit 1
                fi
            else
                succesDownloadOut=$downloadOut4
            fi
        else
            succesDownloadOut=$downloadOut3
        fi
    else
        succesDownloadOut=$downloadOut2
    fi
else
    succesDownloadOut=$downloadOut1
fi
downloadOut=$succesDownloadOut

# Now we have downloaded the archive, and we need to analyze this
# The download have returned both {filename_effective} and {url_effective}

archiveTempName=$( echo "${downloadOut}" | head -1 )
echo "archiveTempName: $archiveTempName"
archivePath=$( echo "${downloadOut}" | tail -1 )
echo "archivePath: $archivePath"

# The two fields retuurned can be exchanged, so some servers return the filename on the other variable. Don't know why.
# So we want to investigate which one has the filename
try1archiveName=${${archiveTempName##*/}%%\?*}
try2archiveName=${${archivePath##*/}%%\?*}
fileName_re='^([a-zA-Z0-9\_.%-]*)\.(dmg|pkg|zip|tbz|gz|bz2)$' # regular expression for matching
if [[ "${try1archiveName}" =~ $fileName_re ]]; then
    archiveName=${try1archiveName}
elif [[ "${try2archiveName}" =~ $fileName_re ]]; then
    archiveName=${try2archiveName}
else
    echo "Could not determine archiveName from “$try1archiveName” and “$try2archiveName”"
    #echo "Extensions $archiveTempName:t:e $archivePath:t:e"
    exit 1
fi

# So we found a filename, and now we want to detect the extension and other information
echo "Calculated archiveName: $archiveName"
mv $archiveTempName $archiveName
name=${archiveName%.*}
echo "name: $name"
archiveExt=${archiveName##*.}
type=$archiveExt
echo "archiveExt: $archiveExt"

# Now figuring out the filename extension and handling those situations
if [ "$archiveExt" = "pkg" ]; then
    pkgPath="$archiveName"
    echo "PKG found: $pkgPath"
    pkgInvestigation
elif [ "$archiveExt" = "dmg" ]; then
    echo "Diskimage found"
    dmgInvestigation
elif [ "$archiveExt" = "zip" ] || [ "$archiveExt" = "tbz" ] || [ "$archiveExt" = "bz2" ]; then
    echo "Compressed file found"
    # unzip the archive
    tar -xf "$archiveName"

    # check if app og pkg exists after expanding
    appPath=$(find "$tmpDir" -name "*.app" -maxdepth 2 -print )
    pkgPath=$(find "$tmpDir" -name "*.pkg" -maxdepth 2 -print )
    archiveName=$(find "$tmpDir" -name "*.dmg" -maxdepth 2 -print )

    if [[ $appPath != "" ]]; then
        echo "App found: $appPath"
        appInvestigation
    elif [[ $pkgPath != "" ]]; then
        echo "PKG found: $pkgPath"
        archiveExt="pkgInZip"
        echo "archiveExt: $archiveExt"
        pkgInvestigation
    elif [[ $archiveName != "" ]]; then
        echo "Disk image found: $archiveName"
        archiveExt="dmgInZip"
        echo "archiveExt: $archiveExt"
        dmgInvestigation
    else
        echo "Nothing found in compressed archive."
        exit 9
    fi
fi

identifier=${name:l} # making lower case
identifier=${identifier//\%[0-9a-fA-F][0-9a-fA-F]} # removing certain characters
identifier=${identifier//[ ,._*@$\(\)\-]} # removing more characters from label name
echo "identifier: $identifier"

# github-part to figure out if we can find author and repo, to use our github functions for the label
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
                    # In this if..then we found out if the end parts of the URL was mathing after removinger numbers and dots (and then assuming that only a version was different
                    echo "“$( echo $originalDownloadURL | cut -d "/" -f8- | sed 's/[0-9.]*//g')” and “$( echo $githubDownloadURL | cut -d "/" -f8- | sed 's/[0-9.]*//g')”"
                    echo "Matching without numbers in string.\nVERY LIKELY a version difference."
                    githubError=1
                    echo "Try running again with URL: ${githubDownloadURL}"
                else
                    # If we are here more than numbers and dots didn't match, so maybe this repo has software for several software titles
                    echo "Not a version problem.\nTesting for difference in archiveName."
                    tempName=$(echo ${archiveName%.*} | grep -o "[0-9.]*" )
                    # if archiveName contains several sections of numbers and/or dots, like "Marathon2-20210408-Mac.dmg" that will return 2 and 20210408 so we want to find the longest of these two (or more), assuming that the longest is the version
                    tempName=( $tempName ) # make it an array
                    i=0; max=0; tempString=""
                    echo $tempName | while read tempLine; do
                        ((i++))
                        length[$i]=${#tempLine}
                        if [[ $max -lt $length[$i] ]] ; then
                            max=$length[$i]
                            tempString=$tempLine
                        fi
                    done
                    # Now tempString will have the longest string returned before. So I use that in a search-replace to remove that part and insert regular expression "[0-9.]*" instead as that will match the removed part
                    archiveDestinationName="$(echo $archiveName | sed -E "s/^(.*)$tempString(.*)$/\1[0-9.]*\2/g")"
                    echo "archiveName=\"$archiveDestinationName\""
                    # Now we want to test if the archiveName is working
                    githubDownloadURL=$(downloadURLFromGit "$githubAuthor" "$githubRepo")
                    githubAppNewVersion=$(versionFromGit "$githubAuthor" "$githubRepo")
                    downloadURL=$originalDownloadURL
                    echo "Latest URL on github: $githubDownloadURL \nLatest version: $githubAppNewVersion"
                    # Final evaluation of our result
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
            else
                echo "GitHub URL not matching"
            fi
        fi
    fi
fi

# We are finished downloading and analyzing, so now we need to present the data
echo "\n**********"
echo "\nLabels should be named in small caps, numbers 0-9, “-”, and “_”. No other characters allowed."

if [[ -z $githubError || $githubError != 0 ]]; then
echo "\nappNewVersion is often difficult to find. Can sometimes be found in the filename, sometimes as part of the download redirects, but also on a web page. See redirect and archivePath above if link contains information about this. That is a good place to start"
fi

# Here the label is built, for easy copy and paste
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
    echo "Can be from a hidden repository, or the software title has a number in it."
    ;;
esac

echo "\nAbove should be saved in a file with exact same name as label, and given extension “.sh”."
echo "Put this file in folder “fragments/labels”.\n"
