cherryaudiopolymode)
    name="Polymode Synthesizer"
    type="pkg"
    packageID="com.cherryaudio.pkg.PolymodePackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/polymode-synthesizer/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/polymode-synthesizer-macos-installer?file=Polymode-Synthesizer-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
