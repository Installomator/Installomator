cherryaudionovachord)
    name="Novachord"
    type="pkg"
    packageID="com.cherryaudio.pkg.NovachordPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/novachord-solovox/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/novachord-macos-installer?file=Novachord-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
