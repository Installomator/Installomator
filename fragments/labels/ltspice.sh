itspice)
	# Free software for simulating & designing analog and power circuits
    name="LTspice"
    type="pkg"
    downloadURL="https://ltspice.analog.com/software/LTspice.pkg"
    appNewVersion=$(curl -fsL -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3" https://www.analog.com/en/resources/design-tools-and-calculators/ltspice-simulator.html | awk '/Download for MacOS/{flag=1} /Version/{if(flag){getline; print; flag=0}}' | sed 's/[^0-9.]//g')
    expectedTeamID="6ZM4J3A422"
    ;;