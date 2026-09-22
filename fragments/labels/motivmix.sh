motivmix)
    name="MOTIV Mix"
    type="zip"
    downloadURL=$(curl -fsSIL -o /dev/null -w "%{url_effective}" "https://www.shure.com/en-US/sw/motiv-mix-mac")
    archiveName=${downloadURL##*/}
    appNewVersion=$(printf "%s\n" "$archiveName" | cut -d. -f2-5)
    appCustomVersion(){ echo "$(defaults read /Applications/Shure/MOTIV\ Mix/MOTIV\ Mix.app/Contents/Info.plist CFBundleShortVersionString | sed 's/-release//')" }
    installerTool="${archiveName%.zip}.app"
    CLIInstaller="${installerTool}/Contents/MacOS/installbuilder.sh"
    CLIArguments=( --mode unattended --unattendedmodeui none )
    expectedTeamID="4K6323CXC4"
    ;;
