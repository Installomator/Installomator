praat)
    name="Praat"
    type="dmg"
    praatVersion="$(curl -fs https://www.fon.hum.uva.nl/praat/download_mac.html | grep "for Intel and Apple Silicon):" | cut -d '_' -f2 | cut -c15-)" 
    downloadURL="https://www.fon.hum.uva.nl/praat/praat${praatVersion}_mac.dmg"
    appNewVersion="${praatVersion:0:1}.${praatVersion:1:1}.${praatVersion:2:2}"
    expectedTeamID="J9C6R9XA5W"
    ;;
