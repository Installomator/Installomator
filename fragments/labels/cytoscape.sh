cytoscape)
    name="Cytoscape"
    #appName="Cytoscape Installer.app"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Cytoscape_[0-9._]*_macos_aarch64.dmg"

    elif [[ $(arch) == "i386" ]]; then
        archiveName="Cytoscape_[0-9._]*_macos_x64.dmg"
    fi
    downloadURL="$(downloadURLFromGit cytoscape cytoscape)"
    appNewVersion="$(versionFromGit cytoscape cytoscape)"
    installerTool="Cytoscape Installer.app"
    CLIInstaller="Cytoscape Installer.app/Contents/MacOS/JavaApplicationStub"
    CLIArguments=(-q)
    expectedTeamID="35LDCJ33QT"
    ;;
