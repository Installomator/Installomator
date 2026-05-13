enpass)
    name="Enpass"
    type="pkg"
    downloadURL="https://www.enpass.io/download/macos/website/stable"
    appNewVersion=$(curl -fs "https://www.enpass.io/downloads/" | grep -o 'version [0-9.]*' | head -1 | sed -E 's/version //')
    expectedTeamID="7ADB8CC6TF"
    ;;
