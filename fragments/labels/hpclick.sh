hpclick)
    # HP Click - Printing software for HP DesignJet large format printers
    # https://support.hp.com/us-en/drivers/hp-click-printing-software/15550865
    # HP Product ID: 15550865
    # Bundle ID: com.hp.hpclick
    # Compatibility: macOS 10.4 - 10.15 (may have issues with newer macOS versions)

    name="HP Click"
    type="dmg"

    # Fetch download URL from HP API if not provided
    if [[ -z "$downloadURL" ]]; then
        printlog "Fetching download URL from HP API..."

        # HP API endpoint for driver details
        api_url="https://support.hp.com/wcc-services/swd-v2/driverDetails?authState=anonymous&template=SWDSeriesDownload"

        # API payload (reverse engineered from Safari Web Inspector)
        # These values are specific to HP Click for macOS
        api_payload='{
            "productLineCode": "GE",
            "lc": "en",
            "cc": "us",
            "osTMSId": "18015185915131310124113888731054140111953115",
            "osName": "Mac OS",
            "productNumberOid": 21355055,
            "productSeriesOid": 15550865,
            "platformId": "275027708611380099388405694207665"
        }'

        # Call HP API
        api_response=$(curl -fsS -X POST "$api_url" \
            -H "Accept: application/json, text/plain, */*" \
            -H "Content-Type: application/json" \
            -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
            -H "Origin: https://support.hp.com" \
            -H "Referer: https://support.hp.com/us-en/drivers/hp-click-printing-software/15550865" \
            -d "$api_payload" 2>&1)

        if [[ $? -eq 0 ]] && [[ -n "$api_response" ]]; then
            # Extract download URL from JSON response using pure shell commands
            # Extract fileUrl field value
            downloadURL=$(echo "$api_response" | grep -o '"fileUrl":"[^"]*"' | head -1 | sed 's/"fileUrl":"//;s/"//')

            # Extract version field value
        	appNewVersion=$(echo "$api_response" | grep -o '"version":"[^"]*"' | head -1 | sed 's/"version":"//;s/"//')

            if [[ -n "$downloadURL" ]] && [[ -n "$appNewVersion" ]]; then
                printlog "Found HP Click version: $appNewVersion"
                printlog "Download URL: $downloadURL"
            else
                printlog "ERROR: Failed to parse HP API response"
                printlog "Response preview: ${api_response:0:200}"
                cleanupAndExit 99 "ERROR: Could not extract download URL from HP API"
            fi
        else
            printlog "ERROR: Failed to fetch download URL from HP API"
            printlog "You can manually specify the URL with: DOWNLOAD_URL=\"https://...\""
            cleanupAndExit 99 "ERROR: HP API request failed"
        fi
    fi

    expectedTeamID="6HB5Y2QTA3"
	blockingProcesses=( "HP Click" )
    ;;
