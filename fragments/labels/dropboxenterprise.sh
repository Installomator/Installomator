dropboxenterprise)
    name="Dropbox Enterprise"
    appName="Dropbox.app"
    type="pkg"
    # Handling differens on Apple Silicon and Intel arch
    if [[ $(arch) = "arm64" ]]; then
        printlog "Architecture: arm64"
        downloadURL="https://client.dropbox.com/desktop/desktop-dropbox/requestdownload?install_type=enterprise_install&platform=mac&arch=arm64"
    else
        printlog "Architecture: i386 (not arm64)"
        downloadURL="https://client.dropbox.com/desktop/desktop-dropbox/requestdownload?install_type=enterprise_install&platform=mac&arch=x86_64"
    fi
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -o "Dropbox.*.pkg"  | sed -E 's/.*%20([0-9.]*)\.([x86_64.]|[arm64.])*pkg/\1/g' | tr -d '[:cntrl:]' )
    expectedTeamID="G7HH3F8CAK"
    ;;
