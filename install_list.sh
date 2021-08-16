#!/bin/bash
#----- Preparation --------
source /etc/profile
sudo cd
bashname=Installomator.sh

wget --no-check-certificate --no-cache --no-cookies -O $bashname "https://raw.githubusercontent.com/mathieu244/Installomator/dev/Installomator.sh"
chmod u+x $bashname


#----- Installations --------

utilities_apps=( adobebrackets googlechrome firefox androidfiletransfer cyberduck discord dropbox figma githubdesktop keka libreoffice omnigraffle7 omnioutliner5 omniplan4 omnipresence pitch postman pymol sketch slack vlc zoom zoomclient )

images_apps=( blender camtasia gimp inkscape )

dev_apps=( androidstudio dbeaverce golang jetbrainsintellijideace jetbrainsphpstorm coderunner r rstudio sourcetree sublimetext eclipse-ide eclipse-java eclipse-cpp eclipse-jee eclipse-modeling )

virtualisation_apps=( virtualbox vagrant docker )

microsoft_apps=( microsoftoffice365 microsoftonedrive microsoftonenote microsoftpowerpoint microsoftsharepointplugin microsoftteams microsoftvisualstudiocode microsoftword )

# installation des applications utilitaires
for f in "${utilities_apps[@]}" ; do
    sudo ./Installomator.sh $f DEBUG=0 BLOCKING_PROCESS_ACTION=kill
done

# installation des applications de gestion d'images
for f in "${images_apps[@]}" ; do
    sudo ./Installomator.sh $f DEBUG=0 BLOCKING_PROCESS_ACTION=kill
done

# installation des applications pour le dev
for f in "${dev_apps[@]}" ; do
    sudo ./Installomator.sh $f DEBUG=0 BLOCKING_PROCESS_ACTION=kill
done

# installation des applications de virtualisation
for f in "${virtualisation_apps[@]}" ; do
    sudo ./Installomator.sh $f DEBUG=0 BLOCKING_PROCESS_ACTION=kill
done

# installation des applications de Microsoft
for f in "${microsoft_apps[@]}" ; do
    sudo ./Installomator.sh $f DEBUG=0 BLOCKING_PROCESS_ACTION=kill
done

# ajout de la licence vmware
sudo ./Installomator.sh vmwarefusion DEBUG=0 VM_LICENCE="XXXXX-XXXXX-XXXXX-XXXXX" BLOCKING_PROCESS_ACTION=kill


#----- Finalisations --------

rm -f $bashname

sudo chown -R root:admin /Applications
sudo chmod -R 555 /Applications