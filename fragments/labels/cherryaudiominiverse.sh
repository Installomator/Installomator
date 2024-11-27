cherryaudiominiverse)
    name="Miniverse"
    type="pkg"
    packageID="com.cherryaudio.pkg.MiniversePackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/miniverse/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/miniverse-macos-installer?file=Miniverse-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
