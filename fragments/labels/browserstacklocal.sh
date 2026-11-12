browserstacklocal)
    name="BrowserStackLocal"
    type="pkg"
    downloadURL="https://www.browserstack.com/local-testing/downloads/native-app/BrowserStackLocal.pkg"
    appNewVersion=$(curl -fsL --compressed "https://www.browserstack.com/local-testing/downloads/native-app/mac/appcast.xml" | xmllint --xpath 'string((//*[local-name()="enclosure"])[1]/@*[local-name()="shortVersionString"])' -)
    expectedTeamID="YQ5FZQ855D"
    ;;
