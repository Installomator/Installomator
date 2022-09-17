horos)
    name="Horos"
    type="dmg"
    versionKey="CFBundleGetInfoString"
    appNewVersion=$(curl -fs https://github.com/horosproject/horos/blob/horos/Horos/Info.plist | grep -A 4 "CFBundleGetInfoString" | tail -1 | sed -r 's/.*Horos v([^<]+).*/\1/' | sed 's/ //g')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://horosproject.org/horos-content/Horos"$appNewVersion"_Apple.dmg"
        TeamID="8NDFEW7285"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://horosproject.org/horos-content/Horos"$appNewVersion".dmg"
        TeamID="TPT6TVH8UY"
    fi
    expectedTeamID=$TeamID
    ;;
