microsoftwindowsapp)
    name="Windows App"
    type="pkg"
    packageID="com.microsoft.rdc.macos"
    blockingProcesses=( "Windows App" "Microsoft Remote Desktop" )
    downloadURL="https://go.microsoft.com/fwlink/?linkid=868963"
    appNewVersion="$(curl -is "${downloadURL}" | grep "Location" | grep -o '[0-9][0-9]\.[0-9]*\.[0-9]*')"
    expectedTeamID="UBF8T346G9"
    ;;
