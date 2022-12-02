todoist)
    name="Todoist"
    type="dmg"
    downloadURL="https://todoist.com/mac_app"
    appNewVersion="$(curl -fsIL https://todoist.com/mac_app | grep -i ^location | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')"
    expectedTeamID="S3DD273774"
    ;;
