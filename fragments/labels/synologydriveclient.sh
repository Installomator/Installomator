synologydriveclient)
    name="Synology Drive Client"
    type="pkgInDmg"
    versionKey="CFBundleVersion"
    appFullVersion="$( curl -sf "https://archive.synology.com/download/Utility/SynologyDriveClient" | grep -m 1 "/download/Utility/SynologyDriveClient/" | sed "s|.*>\(.*\)<.*|\\1|" )"
    appNewVersion="$( echo $appFullVersion | sed "s|.*-\(\)|\\1|" )"
    downloadURL="https://global.download.synology.com/download/Utility/SynologyDriveClient/$appFullVersion/Mac/Installer/synology-drive-client-$appNewVersion.dmg"
    expectedTeamID="X85BAK35Y4"
    ;;
