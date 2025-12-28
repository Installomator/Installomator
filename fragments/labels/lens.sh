lens)
    name="Lens"
    Company="Mirantis, Inc."
    type="dmg"
    local xmlContent=$(curl -ks https://api.k8slens.dev/binaries/latest-mac.json | plutil -convert xml1 - -o -)
    if [[ $(arch) == "i386" ]]; then
      downloadURL=$(printf "%s" "${xmlContent}" | xmllint --xpath '(//key[text()="url"]/following-sibling::string[1][not(contains(text(), "arm64")) and contains(text(), "dmg")])[1]/text()' -)
    elif [[ $(arch) == "arm64" ]]; then
      downloadURL=$(printf "%s" "${xmlContent}" | xmllint --xpath '(//key[text()="url"]/following-sibling::string[1][contains(text(), "arm64") and contains(text(), "dmg")])[1]/text()' -)
    fi
    downloadURL="https://downloads.k8slens.dev/ide/${downloadURL}"
    appNewVersion=$(printf '%s' "${xmlContent}" | xmllint --xpath '//key[text()="version"]/following-sibling::string[1]/text()' -)
    expectedTeamID="JJ22T2W355"
    unset xmlContent
    ;;
