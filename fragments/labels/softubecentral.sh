softubecentral)
    name="Softube Central"
    type="pkg"
    packageID="org.softube.com.softubecentral"
    yaml=$(curl -fs "https://softubestorage.b-cdn.net/softubecentraldata/softubecentral/latest-mac.yml")
    appNewVersion="$(echo "$yaml" | grep '^version:' | awk '{print $2}')"
    downloadFile="$(echo "$yaml" | grep '^path:' | awk '{print $2 "%20" $NF}' | sed 's/\-mac.zip$/.pkg/')"
    downloadURL="https://softubestorage.b-cdn.net/softubecentraldata/softubecentral/${downloadFile}"
    expectedTeamID="MQ5XL2PNWK"
    ;;
