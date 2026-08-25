sequelace)
    name="Sequel Ace"
    type="zip"
    downloadURL="$(downloadURLFromGit sequel-ace sequel-ace)"
    appNewVersion="$(curl -fsL "https://api.github.com/repos/sequel-ace/sequel-ace/releases/latest" | awk -F '"' '/"tag_name"/{print $4; exit}' | sed -E 's|^production/||; s|-[0-9]+$||')"
    expectedTeamID="NKQ4HJ66PX"
    ;;
