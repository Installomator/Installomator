nextcloudtalk)
    name="Nextcloud Talk"
    type="dmg"
    downloadURL="https://github.com/nextcloud-releases/talk-desktop/releases/latest/download/Nextcloud.Talk-macos-universal.dmg"
    appNewVersion="$(curl -fsIL ${downloadURL} | grep -i ^location | grep -oE '/v[0-9]+\.[0-9]+\.[0-9]+/' | cut -d '/' -f2 | sed 's/^v//')"
    expectedTeamID="NKUJUXUJ3B"
    ;;
