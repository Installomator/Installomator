cherryaudiogx80)
    name="GX-80"
    type="pkg"
    packageID="com.cherryaudio.pkg.GX-80Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/gx-80/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/gx-80-macos-installer?file=GX-80-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
