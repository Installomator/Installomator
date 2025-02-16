softubecentral)
    name="Softube Central"
    type="pkg"
    packageID="org.softube.com.softubecentral"
    appNewVersion="$(curl -fs "https://www.softube.com/installers" | grep "mac-version=" | cut -d\" -f2 | xargs)"
    downloadURL="https://softubestorage.b-cdn.net/softubecentraldata/softubecentral/Softube%20Central-${appNewVersion}-universal.pkg"
    expectedTeamID="MQ5XL2PNWK"
    ;;
