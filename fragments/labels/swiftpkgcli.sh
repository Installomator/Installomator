swiftpkgcli)
    name="swiftpkg"
    type="pkg"
    packageID="com.codecarton.swiftpkg.cli.installer"
    archiveName="swiftpkg-[0-9.]*-cli.pkg"
    downloadURL=$(downloadURLFromGit codecarton swiftpkg)
    appNewVersion=$(versionFromGit codecarton swiftpkg)
    expectedTeamID="DPXY7JLK67"
    blockingProcesses=( NONE )
    ;;
