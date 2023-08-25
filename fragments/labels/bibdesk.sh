bibdesk)
    name="BibDesk"
    type="zip"
    downloadURL="https://sourceforge.net/projects/bibdesk/files/latest/download"
    appNewVersion="$(curl -sL https://sourceforge.net/projects/bibdesk/files/BibDesk/ | grep -i "latest/download" | sed -n 's:.*BibDesk-\(.*\).zip.*:\1:p')"
    expectedTeamID="J33JTA7SY9"
    ;;
