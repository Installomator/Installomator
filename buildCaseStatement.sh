#!/bin/sh

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

downloadURL=${1?:"need to provide a download URL"}

# Note: this tool _very_ experimental and does not work in many cases


# create temporary working directory
tmpDir=$(dirname $0 )

# change directory to temporary working directory
echo "Changing directory to $tmpDir"
if ! cd "$tmpDir"; then
    echo "error changing directory $tmpDir"
    #rm -Rf "$tmpDir"
    exit 1
fi

# download the dmg
echo "Downloading $downloadURL"
if ! curl --location --fail --silent "$downloadURL" --remote-header-name --remote-name; then
    echo "error downloading $downloadURL"
    exit 2
fi

archivePath=$(find $tmpDir -print )
archiveName=${archivePath##*/}
name=${archiveName%.*}
archiveExt=${archiveName##*.}
identifier=$(echo $name | tr '[:upper:]' '[:lower:]')

if [ "$archiveExt" = "pkg" ]; then
    teamID=$(spctl -a -vv -t install "$archiveName" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()' )
elif [ "$archiveExt" = "dmg" ]; then
    # mount the dmg
    echo "Mounting $archiveName"
    if ! dmgmount=$(echo "Y"$'\n' | hdiutil attach "$archiveName" -nobrowse -readonly | tail -n 1 | cut -c 54- ); then
        echo "Error mounting $archiveName"
        exit 3
    fi
    echo "Mounted: $dmgmount"
    # check if app exists
    
    appPath=$(find "$dmgmount" -name "*.app" -maxdepth 1 -print )
    appName=${appPath##*/}

    # verify with spctl
    echo "Verifying: $appPath"
    if ! teamID=$(spctl -a -vv "$appPath" 2>&1 | awk '/origin=/ {print $NF }'  | tr -d '()' ); then
        echo "Error verifying $appPath"
        exit 4
    fi
    
    hdiutil detach "$dmgmount"
elif [ "$archiveExt" = "zip" ] || [ "$archiveExt" = "tbz" ]; then
    # unzip the archive
    tar -xf "$archiveName"
    
    # check if app exists
    appPath=$(find "$tmpDir" -name "*.app" -maxdepth 2 -print )
    appName=${appPath##*/}
    # verify with spctl
    echo "Verifying: $appPath"
    if ! teamID=$(spctl -a -vv "$appPath" 2>&1 | awk '/origin=/ {print $NF }'  | tr -d '()' ); then
        echo "Error verifying $appPath"
        exit 4
    fi

fi

echo
echo "    $identifier)"
echo "        name=\"$name\""
echo "        type=\"$archiveExt\""
echo "        downloadURL=\"$downloadURL\""
echo "        expectedTeamID=\"$teamID\""
if [ -n "$appName" ] && [ "$appName" != "${name}.app" ]; then
echo "        appName=\"$appName\""
fi
echo "        ;;"
echo 

#if [ -e "${tmpDir}" ]; then
#    #echo "deleting tmp dir"
#    rm -rf "${tmpDir}"
#fi

exit 0