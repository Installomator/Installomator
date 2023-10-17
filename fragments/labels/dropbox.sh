dropbox)
    name="Dropbox"
    type="dmg"
    # Handling differens on Apple Silicon and Intel arch
    if [[ $(arch) = "arm64" ]]; then
        printlog "Architecture: arm64"
        downloadURL="https://www.dropbox.com/download?plat=mac&full=1&arch=arm64"
    else
        printlog "Architecture: i386 (not arm64)"
        downloadURL="https://www.dropbox.com/download?plat=mac&full=1"
    fi
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i "^location" | sed -E 's/.*%20([0-9.]*)\.[arm64.]*dmg/\1/g' | tr -d '[:cntrl:]' )
    expectedTeamID="G7HH3F8CAK"
    ;;
