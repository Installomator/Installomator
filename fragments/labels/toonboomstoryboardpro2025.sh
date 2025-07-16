toonboomstoryboardpro2025)
    name="Storyboard Pro 25"
    type="dmg"
    version=$(curl -s "https://fileshare.toonboom.com/wl/?id=gXDIzUJu4BznZHs9e15WxLJdooDPu6ii" | grep -oE '25\.[0-9]+\.[0-9]+' | sort -V | tail -1)
    build=$(curl -s "https://docs.toonboom.com/help/storyboard-pro-25/storyboard/release-notes/storyboard-pro-25-release-notes.html" | grep -iEo 'build[^0-9]*([0-9]{4,6})' | grep -oE '[0-9]{4,6}')
    appNewVersion=(${version}.${build})
    downloadURL="https://fileshare.toonboom.com/wl/?id=gXDIzUJu4BznZHs9e15WxLJdooDPu6ii&path=${version}%2FSBP25-mac-${build}.dmg&mode=list&download=1"
    folderName="Toon Boom Storyboard Pro 25"
    appName="${folderName}/Storyboard Pro 25.app"
    versionKey="CFBundleVersion"
    expectedTeamID="U5LPYJSPQ3"
    ;;

