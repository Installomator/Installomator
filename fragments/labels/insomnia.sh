insomnia)
    name="Insomnia"
    type="dmg"
    #downloadURL=$(downloadURLFromGit kong insomnia)
    downloadURL=$(curl -fs "https://updates.insomnia.rest/downloads/mac/latest?app=com.insomnia.app&source=website" | grep -o "https.*\.dmg")
    #appNewVersion=$(versionFromGit kong insomnia)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*\/Insomnia.Core.([0-9.]*)\.dmg/\1/')
    expectedTeamID="FX44YY62GV"
    ;;
