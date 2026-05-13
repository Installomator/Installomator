veracrypt-fuse-t)
    name="VeraCrypt"
    type="pkgInDmg"
    archiveName="VeraCrypt_FUSE-T_[0-9.].*\.dmg"
    downloadURL=$(curl -sfL "https://api.github.com/repos/veracrypt/VeraCrypt/releases" | awk -F '"' "/browser_download_url/ && /$archiveName\"/ { print \$4; exit }")
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*_FUSE-T_([0-9.]*.*)\.dmg/\1/g')
    expectedTeamID="Z933746L2S"
    ;;
