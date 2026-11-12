mailviewer)
    name="Mailviewer"
    type="pkg"
    packageID="app.mailviewer.mac.pkg"
    downloadURL="https://updates.mailviewer.app/latest/Mailviewer.pkg"
    appNewVersion=$(getJSONValue "$(curl -fsL "https://updates.mailviewer.app/latest.json")" "pkgVersion")
    expectedTeamID="D7PHX968FZ"
    blockingProcesses=( NONE )
    ;;
