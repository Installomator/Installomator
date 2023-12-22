beyondcomparepro)
    name="Beyond Compare"
    type="zip"
    downloadURL=$( curl -sL "https://www.scootersoftware.com/checkupdates.php?product=bc4&edition=pro&platform=osx&lang=silent" | cut -d= -f5 | cut -d\" -f2 )
    appNewVersion=$( curl -sL "https://www.scootersoftware.com/checkupdates.php?product=bc4&edition=pro&platform=osx&lang=silent" | cut -d= -f7 | cut -d\" -f2 | awk '{gsub(" build ", ".");print}' )
    expectedTeamID="BS29TEJF86"
    ;;
