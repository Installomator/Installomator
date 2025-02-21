cherryaudioatomika)
    name="Atomika"
    type="pkg"
    packageID="com.cherryaudio.pkg.AtomikaPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/atomika-synthesizer/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/atomika-synthesizer-macos-installer?file=Atomika-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
