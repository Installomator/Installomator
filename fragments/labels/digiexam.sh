digiexam)
    name="Digiexam"
    type="tbz"
    downloadURL="https://cdn.crabnebula.app/download/digiexam/digiexam/latest/platform/dmg-universal"
    appNewVersion=$( curl -sL "https://www.digiexam.com/platform/release-notes" | perl -0777 -ne 'print $1 if /isLatest\W+true\W+platform\W+mac[^}]*version\W+([\d.]+)/' )
    expectedTeamID="73T9H7VE4P"
    ;;
