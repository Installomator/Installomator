cherryaudioca2600)
    name="CA2600"
    type="pkg"
    packageID="com.cherryaudio.pkg.CA2600Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/ca2600/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/ca2600-macos-installer?file=CA2600-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
