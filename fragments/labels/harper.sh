harper)
    #credit: @k4id0
    name="Harper"
    type="dmg"
    downloadURL="https://writewithharper.com/desktop/download"
    appNewVersion=$(curl -fsL "https://api.github.com/repos/elijah-potter/harper/releases/latest" | grep '"tag_name"' | sed -E 's/.*"v([0-9.]+)".*/\1/')
    expectedTeamID="PZYM8XX95Q"
    ;;
