reflector4)
    name="Reflector 4"
    type="dmg"
    downloadURL=$(curl -fs https://www.airsquirrels.com/reflector/try | grep -i dmg | grep -o -i -E "https.*" | cut -d '"' -f1)
    appNewVersion=$(echo ${downloadURL} | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="67X2M9MT5G"
    ;;
