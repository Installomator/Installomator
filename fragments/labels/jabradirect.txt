jabradirect)
    name="Jabra Direct"
    type="dmg"
    downloadURL="https://jabraxpressonlineprdstor.blob.core.windows.net/jdo/JabraDirectSetup.dmg"
    expectedTeamID="55LV32M29R"
    appNewVersion=$(curl -fs https://www.jabra.com/Support/release-notes/release-note-jabra-direct | grep -o "Jabra Direct macOS:*.*<" | head -1 | cut -d ":" -f2 | cut -d " " -f2 | cut -d "<" -f1)
    ;;
