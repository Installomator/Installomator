moderncsv)
    name="Modern CSV"
    type="dmg"
    downloadURL="https://moderncsv.com/release/$(curl https://www.moderncsv.com/release/ | grep -o ModernCSV-Mac-v\[0-9\]\*.\[0-9\]\*.\[0-9\]\*.dmg | tail -1)"
    appNewVersion=$(curl https://www.moderncsv.com/release/ | grep -o moderncsv-mac-v\[0-9\]\*.\[0-9\]\*.\[0-9\]\*.dmg | tail -1 | grep -Eo '([0-9]+)(\.?[0-9]+)*' | head -1)
    expectedTeamID="HV2WS8735K"
    ;;
