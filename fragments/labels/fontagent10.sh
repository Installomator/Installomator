fontagent10)
    name="FontAgent"
    type="pkgInDmg"
    packageID="com.insidersoftware.fontagent10.pkg"
    downloadURL="https://store.insidersoftware.com/_downloads/FontAgent10.dmg"
    appNewVersion="$(curl -fsL "https://updates.insidersoftware.com/software/fontagent10/release/notes.xml" | xpath 'string(//rss/channel/item[1]/enclosure/@sparkle:shortVersionString)')"
    expectedTeamID="936VDEB3YQ"
    blockingProcesses=( "FontAgent" "FontAgent Activator" )
    ;;
