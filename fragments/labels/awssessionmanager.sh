awssessionmanager)
    name="session-manager-plugin"
    type="pkg"
    packageID="session-manager-plugin"
    downloadURL="https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac_arm64/session-manager-plugin.pkg"
    appNewVersion="curl -s "https://docs.aws.amazon.com/systems-manager/latest/userguide/aws-systems-manager-user-guide-updates.rss" | grep -oE 'aws-systemsmanager-plugins/macos/amd64/[^"]+\.pkg' | grep -oE '1\.2\.7'"
    expectedTeamID="94KV3E626L"
    ;;
