    displaynote)
    name="displaynote"
    type="pkg"
    packageID="com.displaynote.DisplayNoteApp"
    downloadURL="https://montage-updates.displaynote.com/api/download/f10632d2-9fbf-11e8-8999-ff918fb3468a/vanilla/released/last?app_name=displaynote-mac"
    appNewVersion="$(curl -fsIL "https://montage-updates.displaynote.com/api/download/f10632d2-9fbf-11e8-8999-ff918fb3468a/vanilla/released/last?app_name=displaynote-mac" | grep -i ^Content-Disposition | sed -n 's/.*displaynote-mac-\([0-9.]*\)-released\.pkg.*/\1/p')"
    expectedTeamID="Q3ML87W6WF"
    ;;
