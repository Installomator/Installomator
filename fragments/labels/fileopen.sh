fileopen)
    name="FileOpen"
    type="pkgInDmg"
    packageID="com.fileopen.client.FileOpenDCTrace.pkg"
    appCustomVersion() { pkgutil --pkg-info com.fileopen.client.FileOpenDC.trace.pkg 2>/dev/null | awk '/^version:/ {print $2}'; }
    downloadURL="https://plugin.fileopen.com/current-mac/FileOpenInstaller.dmg"
    expectedTeamID="U89NDV68NZ"
    blockingProcesses=( NONE )
    ;;
