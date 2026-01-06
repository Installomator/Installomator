citrixworkspace)
    name="Citrix Workspace"
    type="pkg"
    parseURL=$(curl -fs "https://downloadplugins.citrix.com/ReceiverUpdates/Prod/catalog_macos.xml" | xmllint --xpath 'string(//Installer/DownloadURL)' -)
    downloadURL=https://downloadplugins.citrix.com/ReceiverUpdates/Prod/$parseURL
    appNewVersion=$(curl -fs "https://downloadplugins.citrix.com/ReceiverUpdates/Prod/catalog_macos.xml" | xmllint --xpath 'string(//Installer/Version)' -)
    versionKey="CitrixVersionString"
    expectedTeamID="S272Y5R93J"
    ;;
