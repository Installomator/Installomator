ltspice)
    name="LTspice"
    type="pkg"
    packageID="com.analog.LTspice"
    downloadURL="https://ltspice.analog.com/software/LTspice.pkg"
    appNewVersion=$(curl -fs "https://www.analog.com/en/resources/design-tools-and-calculators/ltspice-simulator.html" -H "Accept: text/html" -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.1 Safari/605.1.15" -H "Accept-Encoding: gzip, deflate" --compressed | grep -oE '[0-9]+\.[0-9.]+' | sed -n '4p')
    expectedTeamID="6ZM4J3A422"
    ;;
