zotero)
    name="Zotero"
    type="dmg"
    downloadURL="https://www.zotero.org/download/client/dl?channel=release&platform=mac&version=$(curl -fs "https://www.zotero.org/download/" | grep -Eio '"mac":"(.*)' | cut -d '"' -f 4)"
    expectedTeamID="8LAYR367YV"
    appNewVersion=$(curl -fs "https://www.zotero.org/download/" | grep -Eio '"mac":"(.*)' | cut -d '"' -f 4)
    #Company="Corporation for Digital Scholarship"
    ;;
