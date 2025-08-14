domzilla-caffeine)
    name="Caffeine"
    type="zip"
    appNewVersion=$(curl -s https://www.caffeine-app.net | grep -Eo "Version [0-9]+\.[0-9]+\.[0-9]+" | sed 's/Version //')
    downloadURL="https://dr-caffeine-mac.s3.amazonaws.com/Caffeine_${appNewVersion}.zip"
    packageID="net.domzilla.caffeine"
    expectedTeamID="568T6RKXH7"
    ;;