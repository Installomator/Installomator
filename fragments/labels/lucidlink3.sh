lucidlink3)
    name="LucidLink"
    type="pkg"
    downloadURL=$(curl -fsIL -o /dev/null -w '%{url_effective}' "https://www.lucidlink.com/download/new-ll-latest/macos/stable/")
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/lucidlink-([0-9.]+)\.pkg$|\1|')
    expectedTeamID="Y4KMJPU2B4"
    ;;
