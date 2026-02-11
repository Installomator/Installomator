minecraftedu)
    name="minecraft-edu"
    type="dmg"
    downloadURL="https://aka.ms/meeclientmacos"
    appNewVersion="curl -fsI ${downloadURL} | tr -d '\r' | grep -i ^location | cut -d "/" -f6 | cut -d "_" -f3 | cut -d "." -f1-4"
    expectedTeamID="UBF8T346G9"
    ;;
