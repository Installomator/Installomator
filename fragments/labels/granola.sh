granola)
    name="Granola"
    type="dmg"
    # Uses Homebrew Cask API (does not require Homebrew installation)
    # Most reliable as it's community-maintained and always up-to-date
    granolaJSON=$(curl -fsL "https://formulae.brew.sh/api/cask/granola.json")
    appNewVersion=$(getJSONValue "$granolaJSON" "version")
    downloadURL=$(getJSONValue "$granolaJSON" "url")
    expectedTeamID="QZ7DHHLN25"
    ;;
