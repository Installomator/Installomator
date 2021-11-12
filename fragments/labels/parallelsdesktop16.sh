parallelsdesktop16)
    name="Parallels Desktop"
    #appName="Install.app"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        downloadURL="https://www.parallels.com/directdownload/pd16/intel/?experience=enter_key"
    elif [[ $(arch) == arm64 ]]; then
        downloadURL="https://www.parallels.com/directdownload/pd16/m1/?experience=enter_key"
    fi
    appNewVersion=$( curl -fsIL "$downloadURL" | grep -i "^location" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-[0-9]*\..*/\1/g' )
    expectedTeamID="4C6364ACXT"
    CLIInstaller="Install.app/Contents/MacOS/Install"
    CLIArguments=(install -t "/Applications/Parallels Desktop.app")
    #Company="Parallels"
    #PatchSkip="YES"
        ;;

