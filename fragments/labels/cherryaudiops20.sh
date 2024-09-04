cherryaudiops20)
    name="PS-20"
    type="pkg"
    packageID="com.cherryaudio.pkg.PS-20Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/ps-20/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/ps-20-macos-installer?file=PS-20-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
