burpsuitecommunityedition)
    name="Burp Suite Community Edition"
    type="dmg"
    appNewVersion=$(curl -s https://portswigger.net/burp/releases | grep 'releases/professional-community' | head -n 1 | sed 's/.*href="//' | sed 's/".*//' | cut -d '/' -f4 | cut -d '-' -f3-6 | sed -r 's/-/./g')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://portswigger.net/burp/releases/startdownload/?product=community&version&="$appNewVersion"&type=macosarm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://portswigger.net/burp/releases/startdownload/?product=community&version&="$appNewVersion"&type=macosx"
    fi
    expectedTeamID="N82YM748DZ"
    ;;
