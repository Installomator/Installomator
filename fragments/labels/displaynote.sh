displaynote)
    name="displaynote"
    type="pkg"
    packageID="com.displaynote.DisplayNoteApp"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://montage-updates.displaynote.com/api/download/f10632d2-9fbf-11e8-8999-ff918fb3468a/vanilla_arm64/released/last?app_name=displaynote-mac-arm64"
    else
        downloadURL="https://montage-updates.displaynote.com/api/download/f10632d2-9fbf-11e8-8999-ff918fb3468a/vanilla/released/last?app_name=displaynote-mac"
    fi
    appNewVersion="$(curl -fsIL "$downloadURL" | grep -i '^content-disposition' | sed -nE 's/.*displaynote-mac(-arm64)?-([0-9.]+)-released\.pkg.*/\2/p')"
    expectedTeamID="Q3ML87W6WF"
    ;;
