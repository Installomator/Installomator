gdevelop)
    name="GDevelop 5"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        archiveName="GDevelop-5-[0-9.]*-arm64.dmg"
    elif [[ $(arch) == i386 ]]; then
        archiveName="GDevelop-5-[0-9.]*.dmg" 
    fi
    appNewVersion="$(versionFromGit 4ian GDevelop)"
    downloadURL="$(downloadURLFromGit 4ian GDevelop)"
    expectedTeamID="5CG65LEVUK"
    ;;
