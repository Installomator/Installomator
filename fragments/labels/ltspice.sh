ltspice)
    name="LTspice"
    type="pkg"
    packageID="com.analog.ltspice"
    downloadURL="https://ltspice.analog.com/software/LTspice_26.pkg"
    appNewVersion=$(curl -fsL "https://formulae.brew.sh/api/cask/ltspice.json" | sed -nE 's/.*"version":"([^"]+)".*/\1/p' | head -n 1)
    expectedTeamID="6ZM4J3A422"
    ;;
