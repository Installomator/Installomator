sessionmanagerplugin)
    name="session-manager-plugin"
    type="pkg"
    packageID="session-manager-plugin"
    downloadURL="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac_arm64/session-manager-plugin.pkg"
    appNewVersion=$(curl -s "https://docs.aws.amazon.com/systems-manager/latest/userguide/aws-systems-manager-user-guide-updates.rss" | awk -F'[<>]' '/Session Manager plugin for the AWS CLI/{for(i=1;i<=NF;i++){if($i ~ /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/){print $i}}}')   
    expectedTeamID="94KV3E626L"
    ;;
