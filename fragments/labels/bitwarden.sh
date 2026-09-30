bitwarden)
    name="Bitwarden"
    type="dmg"
    downloadURL="https://vault.bitwarden.com/download/?app=desktop&platform=macos"
    appNewVersion=$(curl -fsIL "$downloadURL" -o /dev/null -D - | awk 'BEGIN{IGNORECASE=1}/^location:/{gsub("\r",""); print $2}' | grep '/bitwarden/clients/releases/download/desktop-v' | head -n 1 | sed -E 's|.*/desktop-v([0-9]+(\.[0-9]+)+)/.*|\1|')
    expectedTeamID="LTZ2PFU5D6"
    ;;
