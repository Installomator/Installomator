cherryaudiogalacticreverb)
    name="Galactic Reverb"
    type="pkg"
    packageID="com.cherryaudio.pkg.GalacticPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/galactic-reverb/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/galactic-reverb-macos-installer?file=Galactic-Reverb-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
