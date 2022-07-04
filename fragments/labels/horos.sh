horos)
    name="Horos"
    type="dmg"
    versionKey="CFBundleGetInfoString"
    appNewVersion=$(curl -fs https://github.com/horosproject/horos/blob/horos/Horos/Info.plist | grep -A 4 "CFBundleGetInfoString" | tail -1 | sed -r 's/.*Horos v([^<]+).*/\1/' | sed 's/ //g')
    downloadURL="https://horosproject.org/horos-content/Horos"$appNewVersion".dmg"
    expectedTeamID="TPT6TVH8UY"
    ;;
