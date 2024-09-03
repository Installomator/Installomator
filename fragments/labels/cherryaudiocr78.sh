cherryaudiocr78)
    name="CR-78"
    type="pkg"
    packageID="com.cherryaudio.pkg.CR-78Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/cr-78/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/cr-78-macos-installer?file=CR-78-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
