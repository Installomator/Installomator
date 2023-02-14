obs)
    # credit: Gabe Marchan (gabemarchan.com - @darklink87)
    name="OBS"
    type="dmg"
    downloadURL=$(curl -fs "https://obsproject.com/download" | awk -F '"' "/dmg/ {print \$10}")
    expectedTeamID="2MMRE5MTB8"
    ;;
