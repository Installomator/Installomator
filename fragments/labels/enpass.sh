enpass)
    name="Enpass"
    type="pkg"
    downloadURL=$(curl -fs "https://www.enpass.io/downloads/" | grep -o 'https://dl.enpass.io/stable/mac/package/[0-9.]*/Enpass.pkg' | head -1)
    appNewVersion=$(curl -fs "https://www.enpass.io/downloads/" | grep -o 'version [0-9.]*' | head -1 | sed -E 's/version //')
    expectedTeamID="7ADB8CC6TF"
    ;;
