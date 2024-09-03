cherryaudiowurlybird140b)
    name="Wurlybird 140B"
    type="pkg"
    packageID="com.cherryaudio.pkg.Wurlybird140bPackage-StandAlone"
    appNewVersion="$(curl -fs https://cherryaudio.com/products/wurlybird140b/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/wurlybird140b-macos-installer?file=Wurlybird140B.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
