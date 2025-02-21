emacs)
    name="Emacs"
    type="dmg"
    downloadURL="$(curl -fsL "https://emacsformacosx.com/atom/release" | xpath '//feed/entry[1]/content/div/p/a' 2>/dev/null | cut -d '"' -f 2)"
    appNewVersion="$(echo "${downloadURL}" | sed -n 's/.*Emacs-\([0-9.-]*\)-universal.dmg/\1/p')"
    expectedTeamID="5BRAQAFB8B"
    ;;
