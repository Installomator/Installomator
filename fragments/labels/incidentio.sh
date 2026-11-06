incidentio)
    name="incident.io"
    type="zip"
    appNewVersion=$(curl -fsL "https://storage.googleapis.com/incident-io-production-downloads/appcast.xml" | grep -Eo 'shortVersionString(="|>)[0-9.]+' | grep -Eo '[0-9.]+$' | sort -V | tail -1)
    downloadURL="https://storage.googleapis.com/incident-io-production-downloads/incident.io-${appNewVersion}.zip"
    expectedTeamID="2B35RJ426W"
    ;;
