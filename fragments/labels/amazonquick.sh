amazonquick)
    name="Amazon Quick"
    type="pkg"
    packageID="com.amazon.QuickWork.mac"
    appNewVersion=$(curl -fsSL "https://desktop.downloads.quick.aws.com/darwin/arm64/quick-external-cloud-mac.yml" | awk '/^version:/ {print $2}')
    downloadURL="https://desktop.downloads.quick.aws.com/darwin/arm64/quick-external-cloud/Amazon%20Quick-${appNewVersion}-arm64.pkg"
    expectedTeamID="94KV3E626L"
    blockingProcesses=("Amazon Quick")
    ;;
