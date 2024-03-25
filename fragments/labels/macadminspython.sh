macadminspython)
    name="MacAdmins Python"
    type="pkg"
    packageID="org.macadmins.python.recommended"
    downloadURL=$(curl --silent --fail "https://api.github.com/repos/macadmins/python/releases/latest" | awk -F '"' "/browser_download_url/ && /python_recommended_signed/ { print \$4; exit }")
    appNewVersion=$(grep -o -E '\d+\.\d+\.\d+\.\d+' <<< $downloadURL | head -n 1)
    expectedTeamID="T4SK8ZXCXG"
    blockingProcesses=( NONE )
    ;;
