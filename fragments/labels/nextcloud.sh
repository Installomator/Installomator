nextcloud)
    name="nextcloud"
    type="pkg"
    archiveName="Nextcloud-[0-9.]*-macOS-vfs.pkg"
    downloadURL=$(downloadURLFromGit nextcloud-releases desktop)
    appNewVersion=$(versionFromGit nextcloud-releases desktop)
    expectedTeamID="NKUJUXUJ3B"
    ;;
