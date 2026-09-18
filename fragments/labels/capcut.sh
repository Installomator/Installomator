capcut)
    name="CapCut"
    type="dmg"
    # The public download button only serves a small "CapCut Downloader" stub app.
    # The stub asks this settings endpoint for the current stable build, so we do the same.
    capcutSettingsURL="https://editor-api-sg.capcutapi.com/service/settings/v3/?aid=359289&device_platform=mac&channel=capcutpc_0&version_code=1&os_version=15.0&region=US&traffic_type=release"
    downloadURL=$(curl -fsL "$capcutSettingsURL" | grep -oE '"lastest_stable_url": *"[^"]+"' | sed -E 's/.*"([^"]+)"$/\1/')
    # Example URL: .../packages/CapCut_9_4_1_4574_capcutpc_0_creatortool.dmg -> 9.4.1.4574
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*CapCut_([0-9]+(_[0-9]+)+)_capcutpc.*\.dmg/\1/' | tr '_' '.')
    expectedTeamID="22MMUN2RN5"
    ;;