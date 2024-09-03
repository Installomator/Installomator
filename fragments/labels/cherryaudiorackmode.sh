cherryaudiorackmode)
    name="Rackmode"
    type="pkg"
    packageID="com.cherryaudio.pkg.RackmodePackage-StandAlone"
    blockingProcesses=( "Rackmode Frequency Shifter" "Rackmode Graphic EQ" "Rackmode Parametric EQ" "Rackmode Phaser" "Rackmode Ring Modulator" "Rackmode String Filter" "Rackmode Vocoder" "Rackmode Vocoder FX" )
    appNewVersion="$(curl -fs https://cherryaudio.com/products/rackmode/version-history | grep -A 6 "info" | grep -Eo "([0-9]+(\.[0-9]+)+)" | head -1 | xargs)"
    downloadURL="https://store.cherryaudio.com/downloads/rackmode-macos-installer?file=Rackmode-Installer-macOS.pkg"
    expectedTeamID="A2XFV22B2X"
    ;;
