typinator)
    name="Typinator"
    type="zip"
    downloadURL=https://update.ergonis.com/downloads/products/typinator/Typinator.app.zip
    appNewVersion="$(curl -fs https://update.ergonis.com/vck/typinator.xml | grep -i Program_Version | sed "s|.*>\(.*\)<.*|\\1|")"
    expectedTeamID="TU7D9Y7GTQ"
    ;;
