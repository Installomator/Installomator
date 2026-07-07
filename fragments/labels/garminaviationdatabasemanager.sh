garminaviationdatabasemanager)
    name="Garmin Aviation Database Manager"
    type="pkg"
    downloadURL="$(curl -fs "https://fly.garmin.com/fly-garmin/garmin-aviation-database-manager/" | grep -Eo "https://static.garmin.com/apps/fly/files/desktop/mac[^\"']*garminAvnDbManagerSetup_[0-9]+(\\.[0-9]+)*\\.pkg" | head -n1)"
    appNewVersion="$(echo "${downloadURL}" | sed -E 's/.*garminAvnDbManagerSetup_([0-9]+(\.[0-9]+)*)\.pkg/\1/')"
    expectedTeamID="72ES32VZUA"
    ;;
