keybase)
    name="Keybase"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL=$(curl -s https://keybase.io/docs/the_app/install_macos | grep data-target | cut -d '"' -f2 | grep arm64 )
        appNewVersion=$( curl -sfL https://prerelease.keybase.io/update-darwin-arm64-prod-v2.json | grep '"version": '  | awk '{print $2}' | awk -F\" '{print $2}' )
    elif [[ $(arch) == i386 ]]; then
        downloadURL=$(curl -s https://keybase.io/docs/the_app/install_macos | grep data-target | cut -d '"' -f2 | grep -v arm64 )
        appNewVersion=$( curl -sfL https://prerelease.keybase.io/update-darwin-prod-v2.json | grep '"version": '  | awk '{print $2}' | awk -F\" '{print $2}' )
    fi
    expectedTeamID="99229SGT5K"
    ;; 
