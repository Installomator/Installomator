teladocproviderinstaller)
    name="TeladocProviderInstaller"
    type="pkg"
    appNewVersion=$(curl -fsL "https://update.intouchreports.com/cdn/PROD/ida/provider/mac/universal/manual/latest-mac.yml" | grep -E 'version: ' | sed -E 's/version: \"?([0-9.]*)\"?/\1/')
    downloadURL="https://update.intouchreports.com/cdn/PROD/ida/provider/mac/universal/manual/TeladocProviderInstaller_${appNewVersion}_mac_universal_manual.pkg"
    packageID="com.intouchhealth.ith-provider"
    expectedTeamID="TXR7NRCG98"
    ;;