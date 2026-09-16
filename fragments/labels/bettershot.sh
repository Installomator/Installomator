bettershot)
    name="BetterShot"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(downloadURLFromGit "KartikLabhshetwar" "better-shot")
        appNewVersion=$(versionFromGit "KartikLabhshetwar" "better-shot")
    else
        archiveName="bettershot-x86_64.dmg"
        downloadURL=$(downloadURLFromGit "KartikLabhshetwar" "better-shot")
        appNewVersion=$(versionFromGit "KartikLabhshetwar" "better-shot")
    fi
    expectedTeamID="8JL39GK2DC"
    ;;
