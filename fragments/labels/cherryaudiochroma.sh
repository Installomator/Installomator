cherryaudiochroma)
    name="Chroma"
    type="pkg"
    packageID="com.cherryaudio.pkg.ChromaPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/chroma/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/chroma-macos-installer?file=Chroma-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
