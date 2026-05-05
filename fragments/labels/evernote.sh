evernote)
    name="Evernote"
    type="dmg"
    downloadURL="$(curl -fs 'https://public.evernote.com/ddl-updater/updater/mac/public/latest-mac.yml' -H 'x-app-version: 11.00.0' -H 'x-os-release: 26.0.0' | awk -F'url:[[:space:]]*' '/url:[[:space:]]*.*\.dmg$/ { print $2 }')"
    appNewVersion=$(curl -fs 'https://public.evernote.com/ddl-updater/updater/mac/public/latest-mac.yml' -H 'x-app-version: 11.00.0' -H 'x-os-release: 26.0.0' | awk -F': *' '/^version:/ { print $2 }')
    expectedTeamID="Q79WDW8YH9"
    ;;
