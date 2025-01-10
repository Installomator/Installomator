defaultfolderx)
    name="Default Folder X"
    type="dmg"
    downloadURL=$(curl -fs "https://www.stclairsoft.com/cgi-bin/dl.cgi?DX" | awk -F '"' "/dmg/ {print \$4}" | head -2 | tail -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*DefaultFolderX-([0-9.]*).dmg/\1/')
    expectedTeamID="7HK42V8R9D"
    ;;
