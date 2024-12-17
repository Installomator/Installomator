cherryaudioquadra)
    name="Quadra"
    type="pkg"
    packageID="com.cherryaudio.pkg.QuadraPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/quadra/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/quadra-macos-installer?file=Quadra-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
