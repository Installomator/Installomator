todoist)
    name="Todoist"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
	    downloadURL=$(curl -fsLI "https://todoist.com/mac_app?arch=arm" | grep -i ^location | sed -E 's/.*(https.*\.dmg).*/\1/g')
    elif [[ $(arch) == i386 ]]; then
        downloadURL=$(curl -fsLI "https://todoist.com/mac_app?arch=x64" | grep -i ^location | sed -E 's/.*(https.*\.dmg).*/\1/g')
    fi
    appNewVersion="$(curl -fsIL https://todoist.com/mac_app | grep -i ^location | sed -E 's/.*-([0-9]+\.[0-9]+\.[0-9]+)-.*/\1/')"
    expectedTeamID="S3DD273774"
    ;;
