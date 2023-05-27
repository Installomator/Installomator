tower)
    name="Tower"
    type="zip"
    downloadURL="https://www.git-tower.com/updates/tower3-mac/stable/releases/latest/download"
    appNewVersion="$(curl -s https://www.git-tower.com/updates/tower3-mac/stable/releases | grep -m1 -o '<h2>[^<]*</h2>' | sed 's/<h2>\(.*\)<\/h2>/\1/' | awk '{print $1}')"
    expectedTeamID="UN97WY764J"
    ;;
