capcut)
    name="CapCut"
    type="dmg"
    capcutDetails=$(curl -fsL "https://editor-api-sg.capcutapi.com/service/settings/v3/?aid=359289&device_platform=mac&channel=capcutpc_0&version_code=1&os_version=15.0&region=US&traffic_type=release")
    downloadURL=$(getJSONValue "$capcutDetails" "data.settings.update_reminder.lastest_stable_url")
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*CapCut_([0-9]+)_([0-9]+)_([0-9]+)_[0-9]+_capcutpc.*\.dmg/\1.\2.\3/')
    expectedTeamID="22MMUN2RN5"
<<<<<<< Updated upstream
    ;;
=======
    ;;
    
>>>>>>> Stashed changes
