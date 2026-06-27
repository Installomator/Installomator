gitcredentialmanager)
    name="Git Credential Manager"
    type="pkg"
    packageID="com.microsoft.gitcredentialmanager"
    appNewVersion=$(versionFromGit git-ecosystem git-credential-manager)
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="https://github.com/git-ecosystem/git-credential-manager/releases/download/v${appNewVersion}/gcm-osx-arm64-${appNewVersion}.pkg"
    else
        downloadURL="https://github.com/git-ecosystem/git-credential-manager/releases/download/v${appNewVersion}/gcm-osx-x64-${appNewVersion}.pkg"
    fi
    expectedTeamID="UBF8T346G9"
    ;;
