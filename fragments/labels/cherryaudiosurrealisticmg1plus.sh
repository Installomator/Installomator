cherryaudiosurrealisticmg1plus)
    name="Surrealistic MG-1 Plus"
    type="pkg"
    packageID="com.cherryaudio.pkg.MG-1PlusPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/surrealistic-mg-1-plus/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/surrealistic-mg-1-plus-macos-installer?file=Surrealistic-MG-1-Plus-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
