zohoworkdrive)
# Using this label expects you to agree to these:
# License Areemant: https://www.zoho.com/workdrive/zohoworkdrive-license-agreement.html
# Privacy policy: https://www.zoho.com/privacy.html
    name="Zoho WorkDrive"
    type="dmg"
    lines=$(curl -fs https://www.zohowebstatic.com/sites/all/themes/zoho/scripts/workdrive.js | grep files-accl.zohopublic.com | tr '"' "\n")
    downloadURL=$(echo "$lines" | grep -i "files-accl.zohopublic.com")$(echo "$lines" | grep -i -A17 "files-accl.zohopublic.com" | grep -i -A2 macintosh | tail -1)
    expectedTeamID="TZ824L8Y37"
    ;;
