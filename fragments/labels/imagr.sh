imagr)
    name="imagr"
    type="dmg"
    downloadURL=$(downloadURLFromGit imagr imagr )
    appNewVersion=$(curl -fsL "https://github.com/imagr/imagr/releases/latest" | xmllint --html --xpath 'substring-after(string(//h1[@class="d-inline mr-3"]), "imagr ")'  - 2> /dev/null)
    ;;