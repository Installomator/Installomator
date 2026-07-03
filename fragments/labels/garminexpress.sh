garminexpress)
    name="Garmin Express"
    blockingProcesses=( "Garmin Express" "Garmin Express Service" )
    type="pkgInDmg"
    downloadURL="https://download.garmin.com/omt/express/GarminExpress.dmg"
    garminJSON="$(curl -fsL https://support.garmin.com/en-US/\?faq\=4QVp7mKSIA1LDk5fc1OHX8 | grep latest | grep -o "{.*}")"
    appNewVersion="$(getJSONValue "$garminJSON" "apiData" "faq" "content" | xmllint --html - 2>/dev/null | grep -o "for Mac: .* as" | grep -o "[0-9].*[0-9]").0"
    expectedTeamID="72ES32VZUA"
    ;;
