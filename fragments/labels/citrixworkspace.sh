citrixworkspace)
    name="Citrix Workspace"
    type="pkgInDmg"
    downloadURL="https://downloadplugins.citrix.com/Mac/CitrixWorkspaceApp.dmg"
    appNewVersion=$(curl -fs "https://downloadplugins.citrix.com/ReceiverUpdates/Prod/catalog_macos.xml" | xmllint --xpath 'string(//Installer/Version)' -)
    versionKey="CitrixVersionString"
    expectedTeamID="S272Y5R93J"
    ;;
