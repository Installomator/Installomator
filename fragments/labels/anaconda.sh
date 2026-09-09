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
    appNewVersion=$(echo "$archiveName" | sed -nE 's/^Anaconda3-([0-9]{4}[.][0-9]{2}-[0-9]+)-MacOSX-(arm64|x86_64)[.]pkg$/\1/p')
    downloadURL="https://repo.anaconda.com/archive/$archiveName"
    appCustomVersion() { pkgutil --pkg-info "$packageID" 2>/dev/null | awk '/^version: / {print $2; exit}'; }
    expectedTeamID="Z5788K4JT7"
    ;;
