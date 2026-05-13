busycal)
    name="BusyCal"
    type="dmg"
    downloadURL="https://www.busymac.com/download/BusyCal.dmg"
    appNewVersion=$( curl -ILs "https://www.busymac.com/download/BusyCal.dmg" | grep -m 1 -i '^location' | sed 's/.*bcl-//' | sed 's/.dmg//' )
    expectedTeamID="N4RA379GBW"
    ;;
    
