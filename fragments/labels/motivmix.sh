motivmix)
    name="MOTIV Mix"
    type="zip"
    downloadURL=$(curl -fsLI "https://www.shure.com/en-US/sw/motiv-mix-mac" | grep -i ^location | sed -E 's/.*(https.*\.zip).*/\1/g')
    archiveName=$(basename ${downloadURL})
    appNewVersion="$(grep -oE "[0-9].*[0-9]" <<< ${archiveName})"
    appCustomVersion(){ echo "$(defaults read /Applications/Shure/MOTIV\ Mix/MOTIV\ Mix.app/Contents/Info.plist CFBundleShortVersionString | sed 's/-release//')" }
    installerTool="$(echo ${archiveName} | sed 's/zip/app/')"
    CLIInstaller="${installerTool}/Contents/MacOS/installbuilder.sh"
    CLIArguments=(--mode unattended --unattendedmodeui none)
    expectedTeamID="4K6323CXC4"
    ;;
