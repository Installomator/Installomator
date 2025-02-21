origin)
     name="Origin"
     type="dmg"
     downloadURL="https://www.dm.origin.com/mac/download/Origin.dmg"
     appNewVersion=$(curl -fsL 'https://api1.origin.com/autopatch/2/upgradeFrom/9.0.000.00000/en_US/PROD?platform=MAC&osVersion=10.16.0' | xpath 'string(//version)' 2>/dev/null)
     expectedTeamID="TSTV75T6Q5"
     ;;
