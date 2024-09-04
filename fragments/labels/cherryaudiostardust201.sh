cherryaudiostardust201)
    name="Stardust 201 Tape Echo"
    type="pkg"
    packageID="com.cherryaudio.pkg.Stardust201Package-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/stardust-201/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/stardust-201-macos-installer?file=Stardust-201-Tape-Echo-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
