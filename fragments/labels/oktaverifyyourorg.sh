oktaverify)
    name="Okta Verify"
    type="pkg"
    oktaTenant=$(defaults read /Library/Managed\ Preferences/com.okta.mobile.plist OktaVerify.OrgUrl)
    if [[ -z "$oktaTenant" ]]; then
      cleanupAndExit "Okta Tenant not set" ERROR
    fi
    downloadURL="https://$oktaTenant/api/v1/artifacts/OKTA_VERIFY_MACOS/download?releaseChannel=GA"
    appNewVersion=$(curl -is "$downloadURL" | grep ocation: | grep -o "OktaVerify.*pkg" | cut -d "-" -f 2)
    expectedTeamID="B7F62B65BN"
    ;;