webcatalog)
    name="WebCatalog"
    type="dmg"
    packageID="com.webcatalog.jordan"
    appNewVersion="$(curl -fs https://webcatalog.io/en/desktop/macos/ | sed -n 's/.*v<!-- -->\([0-9.]*\).*/\1/p')"
    downloadURL="https://cdn-2.webcatalog.io/webcatalog/WebCatalog-${appNewVersion}-universal.dmg"
    expectedTeamID="VKST52VQVP"
    ;;
