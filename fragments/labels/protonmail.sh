protonmail)
    name="Proton Mail"
    type="dmg"
    protonMailData=$(curl -fsL 'https://proton.me/download/mail/macos/version.json')
    protonMailReleaseCount=$(getJSONValue "$protonMailData" 'Releases.length')
    for (( protonMailReleaseIndex=0; protonMailReleaseIndex<protonMailReleaseCount; protonMailReleaseIndex++ )); do
        if [[ $(getJSONValue "$protonMailData" "Releases[$protonMailReleaseIndex].CategoryName") == "Stable" ]]; then
            appNewVersion=$(getJSONValue "$protonMailData" "Releases[$protonMailReleaseIndex].Version")
            downloadURL=$(getJSONValue "$protonMailData" "Releases[$protonMailReleaseIndex].File[0].Url")
            break
        fi
    done
    if [[ -z $appNewVersion || -z $downloadURL ]]; then
        cleanupAndExit 2 "Unable to resolve the latest stable Proton Mail release." ERROR
    fi
    expectedTeamID="2SB5Z68H26"
    ;;
