deepl)
    name="DeepL"
    type="dmg"
    downloadURL="https://appdownload.deepl.com/macos/$(curl -fs https://appdownload.deepl.com/macos/ | grep -o "[0-9]\+\.[0-9]\+/[0-9]\+/DeepL\.dmg" | sort -t'/' -k1,1V -k2,2n | tail -n 1)"
    appNewVersion="$(curl -fs https://appdownload.deepl.com/macos/ | grep -o "[0-9]\+\.[0-9]\+/[0-9]\+/DeepL\.dmg" | sort -t'/' -k1,1V -k2,2n | tail -n 1 | awk -F'/' '{print $1 "." $2}')"
    expectedTeamID="4N8BGCG336"
    ;;
