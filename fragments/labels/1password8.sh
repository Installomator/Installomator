1password8)
    name="1Password"
    type="pkg"
    packageID="com.1password.1password"
    downloadURL="https://downloads.1password.com/mac/1Password.pkg"
    relBuildVer=$(curl -s https://releases.1password.com/mac/ | grep "1Password for Mac" | grep -v Beta | head -n 1 | grep href | cut -d = -f 3 | cut -d / -f 3)
    appNewVersion=$(curl -s "https://releases.1password.com/mac/$relBuildVer/" | grep "c-updates__release" | head -n 1 | awk -F '1Password for Mac |</h6>' '{print $2}')
    expectedTeamID="2BUA8C4S2C"
    blockingProcesses=( "1Password Extension Helper" "1Password 7" "1Password 8" "1Password" "1PasswordNativeMessageHost" "1PasswordSafariAppExtension" )
    #forcefulQuit=YES
    ;;
