yubicoauthenticator)
    name="Yubico Authenticator"
    type="dmg"
    downloadURL="https://developers.yubico.com/yubioath-flutter/Releases/yubico-authenticator-latest-mac.dmg"
    appNewVersion=$(curl -fsI "$downloadURL" | grep -i location | grep -oE "[0-9]+(\.[0-9]+)+")
    expectedTeamID="LQA3CS5MM7"
    ;;
