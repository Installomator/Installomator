cherryaudiosync)
    name="Cherry Audio Sync"
    type="pkg"
    packageID="com.cherryaudio.pkg.SyncPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/sync/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/sync-macos-installer?file=Cherry-Audio-Sync-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
