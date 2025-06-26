masv)
    name="MASV"
    type="dmg"
    downloadURL="https://dl.massive.io/MASV.dmg"
    appNewVersion=$(curl -fsL 'https://dl.massive.io/latest-mac.yml' | grep 'version:' | awk '{print $NF }')
    expectedTeamID="VHKX7RCAY7"
    ;;
