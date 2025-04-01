shutterencoder)
    name="Shutter Encoder"
    type="pkg"
    curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" )
    webSource=$(curl -L $curlOptions --request GET --url "https://www.shutterencoder.com/changelog.html&render_js=1")
    if [[ $(arch) == "arm64" ]]; then
        appNewVersion=$(grep "href=\"Shutter Encoder .* Apple Silicon" <<< $webSource | awk '{print$4}')
        downloadURL=$(grep "APPLE SILICON VERSION" <<< $webSource | grep -oe "https://.*\" class" | sed -e 's/" class//')
    elif [[ $(arch) == "i386" ]]; then
        appNewVersion=$(grep "href=\"Shutter Encoder .* Mac 64bits" <<< $webSource | awk '{print$4}')
        downloadURL=$(grep ">INTEL 64-BITS VERSION" <<< $webSource | grep -oe "https://.*\" class" | sed -e 's/" class//')
    fi
    expectedTeamID="LZ28YRG3Q4"
    ;;
