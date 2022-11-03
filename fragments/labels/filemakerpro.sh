filemakerpro)
    name="FileMaker Pro"
    type="dmg"
    versionKey="BuildVersion"
    downloadURL=$(curl -fs https://www.filemaker.com/redirects/ss.txt | grep '\"PRO..MAC\"' | tail -1 | sed "s|.*url\":\"\(.*\)\".*|\\1|")
    appNewVersion=$(curl -fs https://www.filemaker.com/redirects/ss.txt | grep '\"PRO..MAC\"' | tail -1 | sed "s|.*fmp_\(.*\).dmg.*|\\1|")
    expectedTeamID="J6K4T76U7W"
    ;;
