googlegemini)
    name="Gemini"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dl.google.com/release2/j33ro/release/Gemini.dmg"
    else
        printlog "Gemini is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Gemini requires Apple Silicon" ERROR
    fi
    json=$(curl -Ssf 'https://update.googleapis.com/service/update2/json' -X POST --data-raw '{"request":{"@updater":"GoogleUpdater","domainjoined":true,"protocol":"4.0","dlpref":"cacheable","dedup":"cr","os":{"platform":"MacOSX","version":"26.0.0","arch":"arm64"},"@os":"mac","arch":"arm64","acceptformat":"crx3,download,puff,run,xz,zucc","apps":[{"ap":"m1-prod","enabled":true,"version":"1.00.0.000","updatecheck":{},"appid":"com.google.GeminiMacOS"}]}}' | /usr/bin/tail -c +6)
    appNewVersion=$(echo "$json" | /usr/bin/plutil -extract response.apps.0.updatecheck.nextversion raw -o - -)
    expectedTeamID="EQHXZ8M8AV"
    ;;
