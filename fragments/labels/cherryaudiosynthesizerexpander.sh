cherryaudiosynthesizerexpander)
    name="Synthesizer Expander Module"
    type="pkg"
    packageID="com.cherryaudio.pkg.SynthesizerExpanderModulePackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/synthesizer-expander-module/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/synthesizer-expander-module-macos-installer?file=Synthesizer-Expander-Module-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
