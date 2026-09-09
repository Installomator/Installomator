swiftpkgcombined)
    name="Swiftpkgr"
    type="pkg"
    packageID="com.codecarton.swiftpkg.installer"
    archiveName="swiftpkg-[0-9.]*-combined.pkg"
    downloadURL=$(downloadURLFromGit codecarton swiftpkg)
    appNewVersion=$(versionFromGit codecarton swiftpkg)
    expectedTeamID="DPXY7JLK67"
    ;;
