1password8)
    name="1Password 8"
    appName="1Password.app"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="1Password-latest-aarch64.zip"
        downloadURL="https://downloads.1password.com/mac/1Password-latest-aarch64.zip"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="1Password-latest-x86_64.zip"
        downloadURL="https://downloads.1password.com/mac/1Password-latest-x86_64.zip"
    fi
    expectedTeamID="2BUA8C4S2C"
    blockingProcesses=( "1Password Extension Helper" "1Password 7" "1Password" "1Password (Safari)" "1PasswordNativeMessageHost" "1PasswordSafariAppExtension" )
    #forcefulQuit=YES
    ;;
