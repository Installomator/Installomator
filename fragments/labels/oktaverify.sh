oktaverify)
    name="Okta Verify"
    type="pkg"
    downloadURL="https://okta.okta.com/api/v1/artifacts/OKTA_VERIFY_MACOS/download?releaseChannel=GA&packageType=PKG"
    appNewVersion=$(curl -fsI "$downloadURL" | awk 'BEGIN{IGNORECASE=1}/^location:/{gsub("\r",""); print $2}' | sed -E 's#.*/OktaVerify-([0-9]+(\.[0-9]+)+)-.*\.pkg#\1#')
    expectedTeamID="B7F62B65BN"
    ;;
