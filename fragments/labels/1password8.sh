1password8)
    name="1Password"
    type="pkg"
    packageID="com.1password.1password"
    downloadURL="https://downloads.1password.com/mac/1Password.pkg"
    appNewVersion=$(curl -s https://releases.1password.com/mac/index.xml | grep "1Password for Mac" | grep -v 'beta' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | tail -n 1)
    expectedTeamID="2BUA8C4S2C"
    blockingProcesses=( "1Password Extension Helper" "1Password 7" "1Password 8" "1Password" "1PasswordNativeMessageHost" "1PasswordSafariAppExtension" )
    #forcefulQuit=YES
    ;;
