calibre)
    # credit: Drew Diver (@grumpydrew on MacAdmins Slack)
    name="calibre"
    type="dmg"
    downloadURL="https://calibre-ebook.com/dist/osx"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    #Maybe change to GitHub for this title. Looks like 5.28.0 release is the first to also release a binary, so maybe see what the next release will be to decide if we should switch.
    #downloadURL=$(downloadURLFromGit kovidgoyal calibre )
    #appNewVersion=$(versionFromGit kovidgoyal calibre )
    #archiveName="OS X dmg"
    expectedTeamID="NTY7FVCEKP"
    ;;
