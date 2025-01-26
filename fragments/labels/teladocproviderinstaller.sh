teladocproviderinstaller)
    name="TeladocProviderInstaller"
    type="pkg"
    downloadURL="https://update.intouchreports.com/cdn/prod/ida/provider/mac/x64/manual/TeladocProviderInstaller.pkg"
    appNewVersion=$(curl -fsL "https://update.intouchreports.com/cdn/prod/ida/provider/mac/x64/manual/latest-mac.yml" | grep -E 'version: ' | sed -E 's/version: \"?([0-9.]*)\"?/\1/')
    packageID="com.intouchhealth.ith-provider"
    expectedTeamID="TXR7NRCG98"
    ;;
