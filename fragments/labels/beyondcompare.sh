beyondcompare)
    name="Beyond Compare"
    type="zip"
    fileName=$(curl -sfL -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" https://www.scootersoftware.com/download.php | grep -oE 'BCompareOSX.*\.zip')
    downloadURL="https://www.scootersoftware.com/$fileName"
    appNewVersion=$( sed -nE s/'.*OSX-(.*)\.zip/\1/p' <<< $fileName )
    expectedTeamID="BS29TEJF86"
    ;;

