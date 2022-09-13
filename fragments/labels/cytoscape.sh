cytoscape)
    name="Cytoscape"
    #appName="Cytoscape Installer.app"
    type="dmg"
    downloadURL="$(downloadURLFromGit cytoscape cytoscape)"
    appNewVersion="$(versionFromGit cytoscape cytoscape)"
    installerTool="Cytoscape Installer.app"
    CLIInstaller="Cytoscape Installer.app/Contents/MacOS/JavaApplicationStub"
    CLIArguments=(-q)
    expectedTeamID="35LDCJ33QT"
    ;;
