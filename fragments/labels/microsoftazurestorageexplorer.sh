microsoftazurestorageexplorer)
    name="Microsoft Azure Storage Explorer"
    type="zip"
    if [[ $(arch) == arm64 ]]; then
        archiveName="StorageExplorer-darwin-arm64.zip"
    elif [[ $(arch) == i386 ]]; then
        archiveName="StorageExplorer-darwin-x64.zip" 
    fi
    downloadURL=$(downloadURLFromGit microsoft AzureStorageExplorer )
    appNewVersion=$(versionFromGit microsoft AzureStorageExplorer )
    expectedTeamID="UBF8T346G9"
    ;;
