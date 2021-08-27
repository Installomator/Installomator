smartgit)
    name="SmartGit"
    type="dmg"
    downloadURL="https://www.syntevo.com$(curl -fs "https://www.syntevo.com/smartgit/download/" | grep -i -o -E "/downloads/.*/smartgit.*\.dmg")"
    appNewVersion="$(curl -fs "https://www.syntevo.com/smartgit/changelog.txt" | grep -i -E "SmartGit *[0-9.]* *.*" | head -1 | awk '{print $2}')"
    expectedTeamID="PHMY45PTNW"
    ;;
