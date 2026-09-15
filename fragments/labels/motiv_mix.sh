motiv_mix)
    name="MOTIV Mix"
    type="zip"
    downloadURL=$(curl -fsLI "https://www.shure.com/en-US/sw/motiv-mix-mac" | grep -i ^location | sed -E 's/.*(https.*\.zip).*/\1/g')
    archiveName=$(basename ${downloadURL})
    appNewVersion="${${${archiveName#ShureMOTIVMixInstaller_mac.}%.*}%.*}-release.${${archiveName%.zip}##*.}"
    installerTool="$(echo ${archiveName} | sed 's/zip/app/')"
    CLIInstaller="${installerTool}/Contents/MacOS/installbuilder.sh"
    CLIArguments=(--mode unattended --unattendedmodeui none)
    expectedTeamID="4K6323CXC4"
    ;;
