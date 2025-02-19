cherryaudiovoltagemodular)
    name="Voltage Modular"
    type="pkg"
    packageID="com.cherryaudio.pkg.VoltageModularPackageUniversal-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/voltage-modular/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/voltage-mac/download?file=Voltage-Modular-Installer-macOS-Universal.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
