grandperspective)
    name="GrandPerspective"
    type="dmg"
    downloadURL="https://sourceforge.net/projects/grandperspectiv/files/latest/download"
    appNewVersion=$(curl -fs https://sourceforge.net/projects/grandperspectiv/files/grandperspective/ | grep -B 2 'Download Latest Version' | grep -oE '\/(\d|\.)+\/' | sed 's/\///g')
    expectedTeamID="3Z75QZGN66"
    ;;
