cherryaudiomercury4)
    name="Mercury-4"
    type="pkg"
    packageID="com.cherryaudio.pkg.Mercury-4Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/mercury-4/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/mercury-4-macos-installer?file=Mercury-4-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
