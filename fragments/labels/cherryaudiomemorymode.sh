cherryaudiomemorymode)
    name="Memorymode"
    type="pkg"
    packageID="com.cherryaudio.pkg.MemorymodePackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/memorymode/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/memorymode-macos-installer?file=Memorymode-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
