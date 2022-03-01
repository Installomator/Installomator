calcservice)
    name="CalcService"
    type="zip"
    downloadURL="$(curl -fs -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" "https://www.devontechnologies.com/support/download" | tr '"' "\n" | grep -o "http.*download.*.zip" | grep -i calcservice | head -1)"
    appNewVersion="$(echo $downloadURL | sed -E 's/.*\/([0-9.]*)\/.*/\1/g')"
    expectedTeamID="679S2QUWR8"
    ;;
