bibdesk)
    name="BibDesk"
    type="dmg"
    html_page_source=$(curl -sL https://bibdesk.sourceforge.io)
    downloadURL="$(echo $html_page_source | grep -i "current version" | grep -o 'href="[^"]*' | head -1 | awk -F '="' '{print $NF}')"
    appNewVersion="$(echo $html_page_source | grep -i "current version" | sed -n 's:.*BibDesk-\(.*\).dmg.*:\1:p')"
    expectedTeamID="J33JTA7SY9"
    ;;
