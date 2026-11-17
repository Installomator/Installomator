ltspice)
    name="LTspice"
    type="pkg"
    downloadURL="https://ltspice.analog.com/software/LTspice_26.pkg"
    appNewVersion=$(curl -fsL "https://formulae.brew.sh/api/cask/ltspice.json" | sed -nE 's/.*"version":"([^"]+)".*/\1.1/p' | head -n 1)
    versionKey="CFBundleVersion"
    expectedTeamID="6ZM4J3A422"
    ;;
