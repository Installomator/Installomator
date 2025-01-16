unityhub)
    name="Unity Hub"
    type="dmg"
    downloadURL="https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.dmg"
    appNewVersion=$(curl -s https://unity.com/unity-hub/release-notes | grep -oE '>[0-9]+\.[0-9]+\.[0-9]+<' | head -1 | tr -d '<>')
    expectedTeamID="9QW8UQUTAA"
    ;;

