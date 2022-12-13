druvainsync)
    name="Druva inSync"
    type="pkgInDmg"
    appNewVersion=$(curl -fs https://downloads.druva.com/insync/js/data.json | grep -m1 dmg |awk -F '/' '{print $7}')
    downloadURL=$(curl -fs https://downloads.druva.com/insync/js/data.json | grep -m1 dmg |awk -F '"' '{print $4}')
    expectedTeamID="JN6HK3RMAP"
    ;;
