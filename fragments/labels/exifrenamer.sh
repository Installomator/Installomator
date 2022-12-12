exifrenamer)
    name="ExifRenamer"
    type="dmg"
    downloadURL="https://www.qdev.de/"$(curl -fs "https://www.qdev.de/download.php?file=ExifRenamer.dmg" | grep -o -e "URL=[a-zA-Z/]*.dmg" | cut -d "=" -f2)
    appNewVersion=$(curl -fs "https://www.qdev.de/?location=downloads" | grep -A1 -m1 "ExifRenamer" | tail -1 | cut -d ">" -f2 | cut -d " " -f1)
    expectedTeamID="MLF9FE35AM"
    ;;
