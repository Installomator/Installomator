microsoftglobalsecureaccessclient)
    name="Global Secure Access Client"
    type="pkg"
    packageID="com.microsoft.globalsecureaccess"
    downloadURL="https://aka.ms/GlobalSecureAccess-macOS"
    expectedTeamID="UBF8T346G9"
    appNewVersion=$(curl -sfL https://raw.githubusercontent.com/MicrosoftDocs/entra-docs/refs/heads/main/docs/global-secure-access/reference-macos-client-release-history.md | grep -m1 -E "##.*Version" | grep -E -o "[0-9.]+")
    ;;
