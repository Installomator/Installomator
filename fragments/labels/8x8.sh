8x8)
    name="8x8 Work"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fs -L 'https://support-portal.8x8.com/helpcenter/viewArticle.html?d=8bff4970-6fbf-4daf-842d-8ae9b533153d' | grep -o "https.*arm64-dmg-v[0-9.-]*.dmg" | head -n 1 | sed 's/\"//' | awk '{print $1}')
    else
        downloadURL=$(curl -fs -L 'https://support-portal.8x8.com/helpcenter/viewArticle.html?d=8bff4970-6fbf-4daf-842d-8ae9b533153d' | grep -m 1 -o "https.*dmg" | sed 's/\"//' | awk '{print $1}')
    fi
    # Check newer version than 7.2.4
    appNewVersion=$(curl -fs -L 'https://support-portal.8x8.com/helpcenter/viewArticle.html?d=8bff4970-6fbf-4daf-842d-8ae9b533153d' | grep -m 1 -o "https.*dmg" | sed 's/\"//' | awk '{print $1}' | sed -E 's/.*-v([0-9\.]*)[-\.]*.*/\1/' )
    expectedTeamID="FC967L3QRG"
    ;;
