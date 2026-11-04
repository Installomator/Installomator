microsoftdotnetsdk10)
    name="Microsoft .NET SDK 10"
    type="pkg"
    appNewVersion=$(curl -fsL "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0/latest.version")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://builds.dotnet.microsoft.com/dotnet/Sdk/${appNewVersion}/dotnet-sdk-${appNewVersion}-osx-arm64.pkg"
    else
        downloadURL="https://builds.dotnet.microsoft.com/dotnet/Sdk/${appNewVersion}/dotnet-sdk-${appNewVersion}-osx-x64.pkg"
    fi
    appCustomVersion(){ ls /usr/local/share/dotnet/sdk 2>/dev/null | grep -E '^10\.0\.[0-9]+$' | sort -V | tail -1 }
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( NONE )
    ;;
