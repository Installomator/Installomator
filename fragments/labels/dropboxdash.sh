dropboxdash)
    name="Dropbox Dash"
    type="dmg"
    downloadURL=https://dash-releases.s3.amazonaws.com/$(curl -fs https://dash-releases.s3.amazonaws.com/latest-mac.yml | awk '/url/ && /dmg/ {print $3" "$4}' | sed 's/\ /%20/g' | head -n 1)
    appNewVersion=$(curl -fs https://dash-releases.s3.amazonaws.com/latest-mac.yml | awk '/version/ {print $2}' )
    expectedTeamID="RD4L8RE23W"
    ;;