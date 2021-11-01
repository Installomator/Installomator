zohoworkdrivetruesync)
# Using this label expects you to agree to these:
# License Areemant: https://www.zoho.com/workdrive/zohoworkdrive-license-agreement.html
# Privacy policy: https://www.zoho.com/privacy.html
    name="Zoho WorkDrive TrueSync"
    type="pkg"
    #https://www.zoho.com/workdrive/truesync.html
    #https://files-accl.zohopublic.com/public/tsbin/download/c488f53fb0fe339a8a3868a16d56ede6
    downloadURL=$(curl -fs "https://www.zoho.com/workdrive/truesync.html" | tr '<' '\n' | grep -B3 "For Mac" | grep -o -m1 "https.*\"" | cut -d '"' -f1)
    expectedTeamID="TZ824L8Y37"
    ;;
