cherryaudiops3300)
    name="PS-3300"
    type="pkg"
    packageID="com.cherryaudio.pkg.PS-3300Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/ps-3300/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/ps-3300-macos-installer?file=PS-3300-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
