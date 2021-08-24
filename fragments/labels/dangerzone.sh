dangerzone)
    # credit: Micah Lee (@micahflee)
    name="Dangerzone"
    type="dmg"
    downloadURL=$(curl -s https://dangerzone.rocks/ | grep https://github.com/firstlookmedia/dangerzone/releases/download | grep \.dmg | cut -d'"' -f2)
    expectedTeamID="P24U45L8P5"
    ;;
