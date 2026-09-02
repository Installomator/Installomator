anaconda)
    name="Anaconda-Navigator"
    type="pkg"
    if [[ "$(arch)" == "arm64" ]]; then
        archiveArch="arm64"
        packageID="com.anaconda.pkg.prepare_installation"
    else
        archiveArch="x86_64"
        packageID="io.continuum.pkg.prepare_installation"
    fi
    archiveName=$(curl -fsL "https://repo.anaconda.com/archive/" | awk -v archiveArch="$archiveArch" '/href="Anaconda3-.*MacOSX-.*[.]pkg"/ && $0 ~ "MacOSX-" archiveArch "[.]pkg" {gsub(/.*href="|".*/, ""); print; exit}')
    appNewVersion=$(awk -F'-' '{print $2"-"$3}' <<< "$archiveName")
    downloadURL="https://repo.anaconda.com/archive/$archiveName"
    expectedTeamID="Z5788K4JT7"
    ;;
