googleadseditor)
    name="Google Ads Editor"
    type="dmg"
    downloadURL="https://dl.google.com/adwords_editor/google_ads_editor.dmg"
    appNewVersion="$(curl -s "https://support.google.com/google-ads/editor/topic/13728" | grep -E -o "Google Ads Editor version.{1,4}" | head -1 | tail -c 4)"
    appCustomVersion(){cat /Applications/Google\ Ads\ Editor.app/Contents/Versions/*/Google\ Ads\ Editor.app/Contents/locale/content/welcome1/welcome1-en-US.htm | grep -o -E " about version.{0,4}" | tail -c 4}
    expectedTeamID="EQHXZ8M8AV"
    ;;
