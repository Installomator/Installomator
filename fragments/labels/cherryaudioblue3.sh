cherryaudioblue3)
    name="Blue3 Organ"
    type="pkg"
    packageID="com.cherryaudio.pkg.Blue3Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/blue3-tonewheel-organ/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/blue3-tonewheel-organ-macos-installer?file=Blue3-Organ-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
