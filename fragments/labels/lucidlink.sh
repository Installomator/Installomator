lucidlink)
    name="Lucid"
    type="pkg"
    downloadURL="https://www.lucidlink.com/download/latest/osx/stable"
    appNewVersion=$(curl -fsIL -H "Referer: https://www.lucidlink.com/download/latest/osx/stable" "$downloadURL" | awk 'BEGIN{IGNORECASE=1}/^location:/{gsub("\r",""); print $2}' | tail -n 1 | sed -E 's|.*/lucid-([0-9]+(\.[0-9]+)+)\.pkg$|\1|')
    expectedTeamID="Y4KMJPU2B4"
    ;;
