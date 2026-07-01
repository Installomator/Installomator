garminaviationdatabasemanager)
    name="Garmin Aviation Database Manager"
    type="pkg"
    downloadURL="https://static.garmin.com/apps/fly/files/desktop/mac/electron/channels/2024/garminAvnDbManagerSetup_26.4.23.pkg"
    appNewVersion="$(echo "${downloadURL}" | sed -E 's/.*garminAvnDbManagerSetup_([0-9]+(\.[0-9]+)*)\.pkg/\1/')"
    expectedTeamID="72ES32VZUA"
    ;;
