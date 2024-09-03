cherryaudiodco106)
    name="DCO-106"
    type="pkg"
    packageID="com.cherryaudio.pkg.DCO106Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/dco-106/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/dco-106-macos-installer?file=DCO-106-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
