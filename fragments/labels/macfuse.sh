macfuse)
    name="FUSE for macOS"
    type="pkgInDmg"
    pkgName="Install macFUSE.pkg"
    downloadURL=$(downloadURLFromGit osxfuse osxfuse)
    appNewVersion=$(versionFromGit osxfuse osxfuse)
    appCustomVersion(){
        if [ -f "/Library/Filesystems/macfuse.fs/Contents/Info.plist" ]; then
            defaults read /Library/Filesystems/macfuse.fs/Contents/Info.plist CFBundleShortVersionString
        fi
    }
    expectedTeamID="3T5GSNBU6W"
    ;;
