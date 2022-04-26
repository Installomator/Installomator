camtasia|\
camtasia2021)
    name="Camtasia 2021"
    type="dmg"
    downloadURL=https://download.techsmith.com/camtasiamac/releases/Camtasia.dmg
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links"  | grep "Camtasia (Mac)" | head -1 | sed -e 's/.*Camtasia (Mac) //' -e 's/<\/td>.*//')
    expectedTeamID="7TQL462TU8"
    ;;
