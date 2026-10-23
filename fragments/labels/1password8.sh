1password8)
    name="1Password"
    type="pkg"
    onepassDetails=$(curl -fs "https://app-updates.agilebits.com/check/2/14.6.1/arm64/OPM8/en/80000000/A1/N")
    appNewVersion=$(getJSONValue "${onepassDetails}" "version")
    downloadURL="https://cache.agilebits.com/dist/1P/mac8/1Password-${appNewVersion}.pkg"
    expectedTeamID="2BUA8C4S2C"
    blockingProcesses=( "1Password Extension Helper" "1Password 7" "1Password 8" "1Password" "1PasswordNativeMessageHost" "1PasswordSafariAppExtension" )
    ;;
