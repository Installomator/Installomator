cherryaudioelkax)
    name="Elka-X"
    type="pkg"
    packageID="com.cherryaudio.pkg.Elka-XPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/elka-x/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/elka-x-macos-installer?file=Elka-X-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
