1password8)
    name="1Password"
    type="pkg"
    downloadURL="https://downloads.1password.com/mac/1Password.pkg"
    appNewVersion=$(curl -s https://releases.1password.com/mac/stable/index.xml | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | tail -n1)
    expectedTeamID="2BUA8C4S2C"
    blockingProcesses=( "1Password Extension Helper" "1Password 7" "1Password 8" "1Password" "1PasswordNativeMessageHost" "1PasswordSafariAppExtension" )
    # 1Password 8 is a menu-bar-resident Electron app that traps the
    # AppleScript quit and SIGTERM and keeps running; force SIGKILL so the
    # update isn't aborted by a process that won't close. See issue #2029.
    forcefulQuit="YES"
    ;;
