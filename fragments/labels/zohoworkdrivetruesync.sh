zohoworkdrivetruesync)
# Using this label expects you to agree to these:
# License Areemant: https://www.zoho.com/workdrive/zohoworkdrive-license-agreement.html
# Privacy policy: https://www.zoho.com/privacy.html
    name="Zoho WorkDrive TrueSync"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://files-accl.zohopublic.com/public/tsbin/download/c12aff2fd2a830b382c3ff79cf57ff1d" # beta for M1
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fs "https://www.zoho.com/workdrive/truesync.html" | tr '<' '\n' | grep -B3 "For Mac" | grep -o -m1 "https.*\"" | cut -d '"' -f1)
    fi
    expectedTeamID="TZ824L8Y37"
    ;;
