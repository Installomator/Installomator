defaultfolderx)
    # credit: Gabe Marchan (gabemarchan.com - @darklink87)
    name="Default Folder X"
    type="dmg"
    downloadURL=$(curl -fs "https://www.stclairsoft.com/cgi-bin/dl.cgi?DX" | awk -F '"' "/dmg/ {print \$4}" | head -2 | tail -1)
    expectedTeamID="7HK42V8R9D"
    ;;
