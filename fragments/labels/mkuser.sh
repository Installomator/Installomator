mkuser)
    name="mkuser"
    type="pkg"
    packageID="org.freegeek.pkg.mkuser"
    downloadURL="$(downloadURLFromGit freegeek-pdx mkuser)"
    # appNewVersion="$(versionFromGit freegeek-pdx mkuser unfiltered)"
    # mkuser does not adhere to numbers and dots only for version numbers.
    # Pull request submitted to add an unfiltered option to versionFromGit
    appNewVersion="$(curl -sLI "https://github.com/freegeek-pdx/mkuser/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1)"
    expectedTeamID="YRW6NUGA63"
    ;;
