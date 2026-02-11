kicad)
    name="KiCad"
    type="dmg"
    appNewVersion=$(curl -s "https://api.github.com/repos/KiCad/kicad-source-mirror/releases/latest" | grep '"tag_name":' | cut -d'"' -f4)
    downloadURL="https://github.com/KiCad/kicad-source-mirror/releases/download/${appNewVersion}/kicad-unified-universal-${appNewVersion}.dmg"
    folderName="KiCad"
    appName="${folderName}/KiCad.app"
    versionKey="CFBundleShortVersionString"
    expectedTeamID="9FQDHNY6U2"
    ;;
