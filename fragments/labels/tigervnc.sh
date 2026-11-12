tigervnc)
    name="TigerVNC"
    type="dmg"
    appNewVersion=$(curl -fsL "https://api.github.com/repos/TigerVNC/tigervnc/releases/latest" | awk -F'"' '/"tag_name"/{print $4}' | sed 's/^v//')
    downloadURL="https://downloads.sourceforge.net/project/tigervnc/stable/${appNewVersion}/TigerVNC-${appNewVersion}.dmg"
    expectedTeamID="S5LX88A9BW"
    ;;
