balenaetcher)
    name="balenaEtcher"
    type="dmg"
    version=$(versionFromGit balena-io etcher)
    arch=$(uname -m)
    if [[ "$arch" == "arm64" ]]; then
        downloadURL="https://github.com/balena-io/etcher/releases/download/v${version}/balenaEtcher-${version}-arm64.dmg"
    else
        downloadURL="https://github.com/balena-io/etcher/releases/download/v${version}/balenaEtcher-${version}-x64.dmg"
    fi
    appNewVersion="$version"
    expectedTeamID="66H43P8FRG"
    ;;