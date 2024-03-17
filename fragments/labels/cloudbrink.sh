cloudbrink)
  name="BrinkAgent"
  type="pkg"
  pkgName="BrinkAgent-latest.app"
  appNewVersion=$(curl -sL "https://cloudbrink.com/brink-app-dl/release-notes.txt" | grep -i macos | awk '{print $3}')
  downloadURL="https://cloudbrink.com/brink-app-dl/BrinkAgent-latest.pkg"
  expectedTeamID="DG4B583484"
  blockingProcesses=( "brinkagent" "BrinkAgent" "brinkwatchdog" )
  forcefulQuit=YES
  ;;
