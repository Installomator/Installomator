flameshot)
    name="Flameshot"
    type="dmg"

    releaseJSON=$(curl -fsL "https://api.github.com/repos/flameshot-org/flameshot/releases")

    # Flameshot correctly publishes release metadata through GitHub Releases.
    #
    # Validation performed against multiple production and prerelease tags:
    #
    # Production:
    # v14.0.0
    #
    # Prerelease:
    # v15.0.rc1
    #
    # GitHub metadata correctly identifies prerelease builds using:
    # "prerelease": true
    #
    # Therefore no custom tag filtering is required and production
    # releases can be safely identified using:
    # draft == false
    # prerelease == false
    #
    latestRelease=$(echo "$releaseJSON" | jq -c '
        .[] |
        select(.draft == false) |
        select(.prerelease == false)
    ' | head -1)

    # GitHub release tags are published with a leading "v":
    #
    # v14.0.0
    #
    # The leading "v" is removed to align with the installed
    # application version format used by Installomator.
    #
    appNewVersion=$(echo "$latestRelease" | jq -r '.tag_name' | sed 's/^v//')

    # Architecture-specific installers are published as:
    #
    # Flameshot-14.0-macos-arm64.dmg
    # Flameshot-14.0-macos-intel.dmg
    #
    # Select the appropriate installer based on the current system
    # architecture.
    #
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(echo "$latestRelease" | jq -r '
            .assets[] |
            select(.name | endswith("-macos-arm64.dmg")) |
            .browser_download_url
        ')
    else
        downloadURL=$(echo "$latestRelease" | jq -r '
            .assets[] |
            select(.name | endswith("-macos-intel.dmg")) |
            .browser_download_url
        ')
    fi

    # Flameshot macOS releases currently appear to be unsigned.
    #
    # Validation performed using:
    #
    # codesign -dv /Applications/Flameshot.app
    #
    # No TeamIdentifier was returned and the application does not
    # appear to have a Developer ID signature that can be validated.
    #
    # Because a Team ID is not available, Installomator cannot perform
    # expectedTeamID validation for this application.
    #
    # If the Flameshot project begins signing macOS releases in the
    # future, this label should be updated to include the published
    # Team ID.
    #
    expectedTeamID=""
    ;;
