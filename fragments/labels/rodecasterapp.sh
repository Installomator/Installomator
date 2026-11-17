rodecasterapp)
    name="RODECaster App"
    type="pkgInZip"
    rodecasterJSON=$(curl -fsL "https://update.rode.com/rode-devices-manifest.json")
    downloadURL="https://$(getJSONValue "$rodecasterJSON" '["rc-app-manifest"].macos["main-version"]["download-URL"]' | sed -E 's|^https?://||')"
    appNewVersion=$(getJSONValue "$rodecasterJSON" '["rc-app-manifest"].macos["main-version"]["update-version"]')
    expectedTeamID="Z9T72PWTJA"
    ;;
