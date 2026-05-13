cherryaudiooctavecat)
    name="Octave Cat"
    type="pkg"
    packageID="com.cherryaudio.pkg.OctaveCatPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/octave-cat/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/octave-cat-macos-installer?file=Octave-Cat-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
