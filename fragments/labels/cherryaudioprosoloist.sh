cherryaudioprosoloist)
    name="Pro Soloist"
    type="pkg"
    packageID="com.cherryaudio.pkg.ProSoloistPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/pro-soloist/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/pro-soloist-macos-installer?file=Pro-Soloist-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
