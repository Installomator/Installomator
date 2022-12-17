gitkraken)
    name="gitkraken"
    type="zip"
    darwinversion=$(/usr/bin/uname -r)
    if [[ $(arch) == "arm64" ]]; then
        appNewVersion=$( curl -sfL 'https://release.axocdn.com/darwin-arm64/RELEASES?v=0.0.0&darwin=${darwinversion}' | cut -d, -f1 | cut -d\" -f4 )
        downloadURL=$( curl -sfL 'https://release.axocdn.com/darwin-arm64/RELEASES?v=0.0.0&darwin=${darwinversion}' | cut -d, -f2 | cut -d\" -f4 )
    elif [[ $(arch) == "i386" ]]; then
        appNewVersion=$( curl -sfL 'https://release.axocdn.com/darwin/RELEASES?v=0.0.0&darwin=${darwinversion}' | cut -d, -f1 | cut -d\" -f4 )
        downloadURL=$( curl -sfL 'https://release.axocdn.com/darwin/RELEASES?v=0.0.0&darwin=${darwinversion}' | cut -d, -f2 | cut -d\" -f4 )
    fi
    expectedTeamID="T7QVVUTZQ8"
    ;;
