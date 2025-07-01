microsoft365copilot)
    name="Microsoft 365 Copilot"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=2325438"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_365_Copilot.*pkg" | sed -E 's/.*_([0-9]+\.[0-9]+\.[0-9]+)_.*\.pkg/\1/')
    expectedTeamID="UBF8T346G9"
    ;;
