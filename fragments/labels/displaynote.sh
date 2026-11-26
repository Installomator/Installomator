displaynote)
    name="DisplayNote App"
    type="pkg"
    if [[ "$(arch)" == "arm64" ]]; then
        displaynoteAPI="https://montage-updates.displaynote.com/api/download/f10632d2-9fbf-11e8-8999-ff918fb3468a/vanilla_arm64/released/last?app_name=displaynote-mac-arm64"
    else
        displaynoteAPI="https://montage-updates.displaynote.com/api/download/f10632d2-9fbf-11e8-8999-ff918fb3468a/vanilla/released/last?app_name=displaynote-mac"
    fi
    downloadURL=$(curl -fsSI "$displaynoteAPI" | /usr/bin/sed -nE 's/^[Ll]ocation: *//p' | /usr/bin/tr -d '\r')
    appNewVersion=$(printf '%s\n' "$downloadURL" | /usr/bin/sed -nE 's|.*DisplaynoteMontageClient-([0-9]+(\.[0-9]+)+)(-arm64)?\.pkg.*|\1|p')
    expectedTeamID="Q3ML87W6WF"
    blockingProcesses=( "DisplayNoteApp" )
    ;;
