cherryaudiodreamsynth)
    name="Dreamsynth"
    type="pkg"
    packageID="com.cherryaudio.pkg.DreamsynthPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/dreamsynth/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/dreamsynth-macos-installer?file=Dreamsynth-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
