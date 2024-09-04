cherryaudiolowdown)
    name="Lowdown"
    type="pkg"
    packageID="com.cherryaudio.pkg.LowdownPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/lowdown/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/lowdown-macos-installer?file=Lowdown-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
