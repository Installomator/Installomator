jabradirect)
    name="Jabra Direct"
    type="pkgInDmg"
    # packageID="com.jabra.directonline"
    versionKey="CFBundleVersion"
    downloadURL="https://jabraxpressonlineprdstor.blob.core.windows.net/jdo/JabraDirectSetup.dmg"
    #appNewVersion=$(curl -fs https://www.jabra.com/Support/release-notes/release-note-jabra-direct | grep -oe "Release version:.*[0-9.]*<" | head -1 | cut -d ">" -f2 | cut -d "<" -f1 | sed 's/ //g')
    appNewVersion=$(curl -fs "https://jabraexpressonlinejdo.jabra.com/jdo/jdo.json" | grep -i MacVersion | cut -d '"' -f4)
    expectedTeamID="55LV32M29R"
    ;;
