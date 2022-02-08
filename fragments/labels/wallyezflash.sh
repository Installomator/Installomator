wallyezflash)
    name="Wally"
    type="dmg"
    downloadURL="https://configure.zsa.io/wally/osx"
    # 2022-02-07: Info.plist is totally wrong defined and contains no version information
    #appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i ^location | head -1 | sed -E 's/.*\/[a-zA-Z\-]*-([0-9.]*)\..*/\1/g')
    expectedTeamID="V32BWKSNYH"
    #versionKey="CFBundleVersion"
    ;;
