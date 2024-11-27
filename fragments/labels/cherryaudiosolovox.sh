cherryaudiosolovox)
    name="Solovox"
    type="pkg"
    packageID="com.cherryaudio.pkg.SolovoxPackage-StandAlone"
    appNewVersion="$(curl -fs curl -fs https://cherryaudio.com/products/novachord-solovox/version-history | grep -E -o ".<h4>Solovox</h4>.{0,40}" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/solovox-macos-installer?file=Solovox-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
