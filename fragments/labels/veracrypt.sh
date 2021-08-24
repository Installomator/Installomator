veracrypt)
    name="VeraCrypt"
    type="pkgInDmg"
    #downloadURL=$(curl -s -L "https://www.veracrypt.fr/en/Downloads.html" | grep -Eio 'href="https://launchpad.net/veracrypt/trunk/(.*)/&#43;download/VeraCrypt_([0-9].*).dmg"' | cut -c7- | sed -e 's/"$//' | sed "s/&#43;/+/g")
    downloadURL=$(curl -fs "https://www.veracrypt.fr/en/Downloads.html" | grep "https.*\.dmg" | grep -vi "legacy" | tr '"' '\n' | grep "^https.*" | grep -vi ".sig" | sed "s/&#43;/+/g")
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*.*)\.dmg/\1/g' )
    expectedTeamID="Z933746L2S"
    ;;
