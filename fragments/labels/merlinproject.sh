merlinproject)
    name="Merlin Project"
    type="zip"
    downloadURL="https://www.projectwizards.net/downloads/MerlinProject.zip"
    appNewVersion="$(curl -fs "https://www.projectwizards.net/de/support/release-notes"  | grep Version | head -n 6 | tail -n 1 | sed 's/[^0-9.]*//g')"
    expectedTeamID="9R6P9VZV27"
    ;;
