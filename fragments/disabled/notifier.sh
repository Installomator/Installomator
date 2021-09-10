
notifier)
   # not signed
   # credit: Søren Theilgaard (@theilgaard)
   name="dataJAR Notifier"
   type="pkg"
   #packageID="uk.co.dataJAR.Notifier" # Version 2.2.3 was actually "uk.co.dataJAR.Notifier-2.2.3" so unusable
   downloadURL=$(downloadURLFromGit dataJAR Notifier)
   appNewVersion=$(versionFromGit dataJAR Notifier)
   expectedTeamID=""
   blockingProcesses=( "Notifier" )
   ;;
