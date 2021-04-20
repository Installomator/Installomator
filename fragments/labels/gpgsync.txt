gpgsync)
    # credit: Micah Lee (@micahflee)
    name="GPG Sync"
    type="pkg"
    downloadURL="https://github.com$(curl -s -L https://github.com/firstlookmedia/gpgsync/releases/latest | grep /firstlookmedia/gpgsync/releases/download | grep \.pkg | cut -d'"' -f2)"
    expectedTeamID="P24U45L8P5"
    ;;
