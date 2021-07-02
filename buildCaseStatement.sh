#!/bin/sh

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

downloadURL=${1?:"need to provide a download URL"}

# Note: this tool _very_ experimental and does not work in many cases
# That being said, it's a great place to start for building up the label in the Case-statement

# Usage
# ./buildCaseStatement.sh <URL to download software>


# create temporary working directory
tmpDir=$(dirname $0 )

# change directory to temporary working directory
echo "Changing directory to $tmpDir"
if ! cd "$tmpDir"; then
    echo "error changing directory $tmpDir"
    #rm -Rf "$tmpDir"
    exit 1
fi

# download the URL
echo "Downloading $downloadURL"
if ! downloadOut="$(curl -fsL "$downloadURL" --remote-header-name --remote-name -w "%{filename_effective}\n%{url_effective}\n")"; then
    echo "error downloading $downloadURL"
    exit 2
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
echo "downloadOut: ${downloadOut}"
archiveTempName=$( echo "${downloadOut}" | head -1 )
echo "archiveTempName: $archiveTempName"
archivePath=$( echo "${downloadOut}" | tail -1 )
echo "archivePath: $archivePath"
archiveName=${archivePath##*/}
echo "archiveName: $archiveName"
mv $archiveTempName $archiveName
name=${archiveName%.*}
echo "name: $name"
archiveExt=${archiveName##*.}
echo "archiveExt: $archiveExt"
identifier=$(echo $name | tr '[:upper:]' '[:lower:]')
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
echo "appNewVersion is often difficult to find. Can sometimes be found in the filename, but also on a web page. See archivePath above if link contains information about this."
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

#if [ -e "${tmpDir}" ]; then
#    #echo "deleting tmp dir"
#    rm -rf "${tmpDir}"
#fi

exit 0
