ticktick)
    # TickTick is a x-platform ToDo-app for groups/teams, see https://ticktick.com
    name="TickTick"
    type="dmg"
    downloadURL="https://ticktick.com/down/getApp/download?type=mac"
    appNewVersion="$(curl -fsIL "$downloadURL" | grep -Ei "^location" | cut -d "_" -f2)"
    expectedTeamID="75TY9UT8AY"
    ;;
