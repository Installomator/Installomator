1passwordcli)
    name="1Password CLI"
    type="pkg"
    #packageID="com.1password.op"
    downloadURL=$(curl -fs https://app-updates.agilebits.com/product_history/CLI2 | grep -m 1 -i op_apple_universal | cut -d'"' -f 2)
    appNewVersion=$(echo $downloadURL | sed -E 's/.*\/[a-zA-Z_]*([0-9.]*)\..*/\1/g')
    appCustomVersion(){ /usr/local/bin/op -v }
    expectedTeamID="2BUA8C4S2C"
    ;;
