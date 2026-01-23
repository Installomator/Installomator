unityhub)
    name="Unity Hub"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        downloadURL="https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup-x64.dmg"
    elif [[ $(arch) == arm64 ]]; then
        downloadURL="https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup-arm64.dmg"
    fi
    appNewVersion=$(curl -s https://unity.com/unity-hub/release-notes | grep -oE '>[0-9]+\.[0-9]+\.[0-9]+<' | head -1 | tr -d '<>')
    versionKey="CFBundleVersion"
    expectedTeamID="9QW8UQUTAA"
    ;;

