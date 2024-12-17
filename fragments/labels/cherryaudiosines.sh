cherryaudiosines)
    name="Sines"
    type="pkg"
    packageID="com.cherryaudio.pkg.SinesPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/sines/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/sines-macos-installer?file=Sines-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
