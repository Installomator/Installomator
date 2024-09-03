cherryaudioharmonia)
    name="Harmonia"
    type="pkg"
    packageID="com.cherryaudio.pkg.HarmoniaPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/harmonia/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/harmonia-macos-installer?file=Harmonia-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
