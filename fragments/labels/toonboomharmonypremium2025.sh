toonboomharmonypremium2025)
    name="Harmony 25 Premium"
    type="dmg"
    version=$(curl -s "https://fileshare.toonboom.com/wl/?id=jyhyaYQFJ86iE6daFDh3JJv2g6OFBDza" | grep -oE '25\.[0-9]+\.[0-9]+' | sort -V | tail -1)
    build=$(curl -s "https://docs.toonboom.com/help/harmony-25/premium/release-notes/harmony/harmony-25-release-notes.html" | grep -iEo 'build[^0-9]*([0-9]{4,6})' | grep -oE '[0-9]{4,6}')
    appNewVersion=${version}${build}
    downloadURL="https://fileshare.toonboom.com/wl/?id=jyhyaYQFJ86iE6daFDh3JJv2g6OFBDza&path=${version}%2FHAR25-PRM-mac-${build}.dmg&mode=list&download=1"
    folderName="Toon Boom Harmony 25 Premium"
    appName="${folderName}/Harmony 25 Premium.app"
    versionKey="CFBundleVersion"
    expectedTeamID="U5LPYJSPQ3"
    ;;

