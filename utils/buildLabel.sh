#!/bin/zsh

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

downloadURL=${1?:"need to provide a download URL."}

# Note: this tool _very_ experimental and does not work in many cases
# That being said, it's a great place to start for building up the label in the Case-statement

# Usage
# ./buildLabel.sh <URL to download software>

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

pkgInvestigation() {
    echo "Package found"
    teamID=$(spctl -a -vv -t install "$archiveName" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()' )
    echo "For PKGs it's advised to find packageID for version checking"
    
    pkgutil --expand "$pkgPath" "$archiveName"_pkg
    cat "$archiveName"_pkg/Distribution | xpath '//installer-gui-script/pkg-ref[@id][@version]' 2>/dev/null
    packageID="$(cat "$archiveName"_pkg/Distribution | xpath '//installer-gui-script/pkg-ref[@id][@version]' 2>/dev/null | tr ' ' '\n' | grep -i "id" | cut -d \" -f 2)"
    rm -r "$archiveName"_pkg
    echo "$packageID"
    echo "Above is the possible packageIDs that can be used, and the correct one is probably one of those with a version number. More investigation might be needed to figure out correct packageID if several are displayed."
}
appInvestigation() {
    appName=${appPath##*/}

    # verify with spctl
    echo "Verifying: $appPath"
    if ! teamID=$(spctl -a -vv "$appPath" 2>&1 | awk '/origin=/ {print $NF }'  | tr -d '()' ); then
        echo "Error verifying $appPath"
        exit 4
    fi
}

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
echo "archiveExt: $archiveExt"
identifier=${name:l}
identifier=${identifier//\%[0-9a-fA-F][0-9a-fA-F]}
identifier=${identifier//[,._*@$\(\)\-]}
echo "identifier: $identifier"

if [ "$archiveExt" = "pkg" ]; then
    pkgPath="$archiveName"
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
        appInvestigation
    elif [[ $pkgPath != "" ]]; then
        archiveExt="pkgInDmg"
        pkgInvestigation
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
        appInvestigation
    elif [[ $pkgPath != "" ]]; then
        archiveExt="pkgInZip"
        pkgInvestigation
    fi

fi

echo
echo "**********"
echo
echo "Labels should be named in small caps, numbers 0-9, “-”, and “_”. No other characters allowed."
echo
echo "appNewVersion is often difficult to find. Can sometimes be found in the filename, sometimes as part of the download redirects, but also on a web page. See redirect and archivePath above if link contains information about this. That is a good place to start"
echo
echo "$identifier)"
echo "    name=\"$name\""
echo "    type=\"$archiveExt\""
if [ "$packageID" != "" ]; then
echo "    packageID=\"$packageID\""
fi
echo "    downloadURL=\"$downloadURL\""
echo "    appNewVersion=\"\""
echo "    expectedTeamID=\"$teamID\""
if [ -n "$appName" ] && [ "$appName" != "${name}.app" ]; then
echo "    appName=\"$appName\""
fi
echo "    ;;"
echo
echo "Above should be saved in a file with exact same name as label, and given extension “.sh”."
echo "Put this file in folder “fragments/labels”."
echo


exit 0
