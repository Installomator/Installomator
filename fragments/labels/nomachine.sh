nomachine)
    name="NoMachine"
    type="pkgInDmg"
    downloadURL=$(curl -i -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" https://www.nomachine.com/dwl_nm_bann.php | grep -i location | cut -w -f2 | tr -d '[:cntrl:]')
    appNewVersion=$(echo $downloadURL | grep -Eo "\d+.\d+.\d+")
    expectedTeamID="493C5JZAGR"
    ;;
