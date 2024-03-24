snagit2023)
    name="Snagit 2023"
    type="dmg"
    downloadURL=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links" | grep -A 3 "Snagit (Mac) 2023" | sed 's/.*href="//' | sed 's/".*//' | grep .dmg)
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.techsmith.com/hc/en-us/articles/360004908652-Desktop-Product-Download-Links"  | grep "Snagit (Mac) 2023" | sed -e 's/.*Snagit (Mac) //' -e 's/<\/td>.*//')
    expectedTeamID="7TQL462TU8"
    ;;
