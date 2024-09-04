cherryaudiomercury6)
    name="Mercury-6"
    type="pkg"
    packageID="com.cherryaudio.pkg.Mercury-6Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/mercury-6/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/mercury-6-macos-installer?file=Mercury-6-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
