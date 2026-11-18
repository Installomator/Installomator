fxfactory)
    name="FxFactory"
    type="pkgInZip"
    downloadURL=$(curl -fsL -A "Mozilla/5.0" https://fxfactory.com/download/ | grep -oE 'https://files\.fxfactory\.com/fxfactory/FxFactory-[0-9.]+-[0-9]+\.zip' | sort -u -t- -k2,2V | tail -1)
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*FxFactory-([0-9.]+)-[0-9]+\.zip/\1/')
    pkgName="Install FxFactory*.pkg"
    expectedTeamID="AZLNLGPTT3"
    blockingProcesses=( "FxFactory" "Final Cut Pro" "Motion" )
    ;;
