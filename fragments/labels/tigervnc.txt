tigervnc)
    name="TigerVNC Viewer"
    type="dmg"
    downloadURL=https://dl.bintray.com/tigervnc/stable/$(curl -s -l https://dl.bintray.com/tigervnc/stable/ | grep .dmg | sed 's/<pre><a onclick="navi(event)" href="://' | sed 's/".*//' | sort -V | tail -1)
    expectedTeamID="S5LX88A9BW"
    ;;
