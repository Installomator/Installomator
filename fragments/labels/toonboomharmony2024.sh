toonboomharmonypremium2024)
    name="Harmony 24 Premium"
    type="dmg"
    # appNewVersion=$(curl -s https://docs.toonboom.com/help/harmony-24/premium/release-notes/harmony/harmony-24-release-notes.html | grep -oE 'build [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | awk '{print $2}')
    appNewVersion=$(release_notes_url=$(curl -s "https://docs.toonboom.com/help/harmony-24/premium/book/index.html" | \
    grep -o 'href="[^"]*release-notes/harmony/harmony-24[^"]*"' | \
    head -n 1 | sed -E 's/href="([^"]*)"/\1/')
    curl -s "https://docs.toonboom.com/help/harmony-24/premium/book/$release_notes_url" | \
    grep -oE 'Harmony [0-9]+\.[0-9]+\.[0-9]+, build [0-9]+' | \
    sed 's/,//g' | awk '{print $2 "." $4}')
    version=$(echo "$appNewVersion" | awk -F'.' '{print $1"."$2"."$3}')
    build=$(echo "$appNewVersion" | awk -F'.' '{print $4}')
    downloadURL="https://fileshare.toonboom.com/wl/?id=idRIztLvVCq0EZ00x01BJa6R2EqKp01R&path=${version}%2FHAR24-PRM-mac-${build}.dmg&mode=list&download=1"
    folderName="Toon Boom Harmony 24 Premium"
    appName="${folderName}/Harmony 24 Premium.app"
    versionKey="CFBundleVersion"
    expectedTeamID="U5LPYJSPQ3"
    ;;
    
