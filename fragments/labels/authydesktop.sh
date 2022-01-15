authydesktop)
    name="Authy Desktop"
    type="dmg"
    #downloadURL="https://electron.authy.com/download?channel=stable&arch=x64&platform=darwin&version=latest&product=authy" # redirect from this URL fails on Catalina due to curl version
    downloadURL=$(/usr/bin/curl -s -w '%{redirect_url}' -o /dev/null "https://electron.authy.com/download?channel=stable&arch=x64&platform=darwin&version=latest&product=authy" | sed 's/\ /%20/g')
    appNewVersion="$(curl -sfL --output /dev/null -r 0-0 "${downloadURL}" --remote-header-name --remote-name -w "%{url_effective}\n" | grep -o -E '([a-zA-Z0-9\_.%-]*)\.(dmg|pkg|zip|tbz)$' | sed -E 's/.*-([0-9.]*)\.dmg/\1/g')"
    expectedTeamID="9EVH78F4V4"
    ;;
