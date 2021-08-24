loom)
    # credit: Lance Stephens (@pythoninthegrass on MacAdmins Slack)
    name="Loom"
    type="dmg"
    downloadURL=https://cdn.loom.com/desktop-packages/$(curl -fs https://s3-us-west-2.amazonaws.com/loom.desktop.packages/loom-inc-production/desktop-packages/latest-mac.yml | awk '/url/ && /dmg/ {print $3}' | head -1)
    appNewVersion=$(curl -fs https://s3-us-west-2.amazonaws.com/loom.desktop.packages/loom-inc-production/desktop-packages/latest-mac.yml | awk '/version/ {print $2}' )
    expectedTeamID="QGD2ZPXZZG"
    ;;
