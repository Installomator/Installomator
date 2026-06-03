1password8)
    name="1Password"
    type="pkg"
    appNewVersion=$(curl -fsL "https://app-updates.agilebits.com/product_history/OPM8" | grep -Eo '1Password-[0-9]+([.][0-9]+)+[.]pkg' | head -n 1 | sed -E 's/1Password-([0-9.]+)[.]pkg/\1/')
    downloadURL="https://cache.agilebits.com/dist/1P/mac8/1Password-${appNewVersion}.pkg"
    expectedTeamID="2BUA8C4S2C"
    blockingProcesses=( "1Password Extension Helper" "1Password 7" "1Password 8" "1Password" "1PasswordNativeMessageHost" "1PasswordSafariAppExtension" )
    ;;
