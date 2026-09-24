protonpass)
    name="Proton Pass"
    type="dmg"
    protonPassData=$(curl -fsL 'https://proton.me/download/PassDesktop/darwin/universal/version.json')
    protonPassReleaseCount=$(getJSONValue "$protonPassData" 'Releases.length')
    for (( protonPassReleaseIndex=0; protonPassReleaseIndex<protonPassReleaseCount; protonPassReleaseIndex++ )); do
        if [[ $(getJSONValue "$protonPassData" "Releases[$protonPassReleaseIndex].CategoryName") == "Stable" ]]; then
            appNewVersion=$(getJSONValue "$protonPassData" "Releases[$protonPassReleaseIndex].Version")
            downloadURL=$(getJSONValue "$protonPassData" "Releases[$protonPassReleaseIndex].File[0].Url")
            break
        fi
    done
    if [[ -z $appNewVersion || -z $downloadURL ]]; then
        cleanupAndExit 2 "Unable to resolve the latest stable Proton Pass release." ERROR
    fi
    expectedTeamID="2SB5Z68H26"
    ;;
