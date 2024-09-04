cherryaudiomoduledesigner)
    name="Voltage Module Designer"
    type="pkg"
    packageID="com.cherryaudio.pkg.VoltageModuleDesigner"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/voltage-module-designer/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/module-designer-mac/download?file=Voltage-Module-Designer-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
