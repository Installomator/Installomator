## v10beta3

- option to add item to dock if dockutil is installed (#701 requires dockutil https://github.com/kcrawford/dockutil )
- further improvements to GitHub downloads (#691)
- updated user dialog when app is already on the latest version (#658)

Plus everything from beta1 and beta2.

- new labels:
    - adobeacrobatprodc (#707)
    - adobereaderdc-install (#707)
    - archiwareb2go (#625, #707)
    - archiwarepst (#624)
    - bitrix24 (#661)
    - charles (#670)
    - chronoagent (#617)
    - chronosync (#616)
    - cytoscape (#689)
    - egnytecore (#655)
    - fellow (#599)
    - filemakerpro (#609)
    - fujifilmwebcam (#598)
    - gfxcardstatus (#690)
    - horos (#610)
    - inetclearreportsdesigner (#601)
    - jdk18 (#608)
    - latexit (#684)
    - nudgesuite (#633)
    - origin (#662)
    - parallelsrasclient (#607)
    - polylens (#671)
    - splashtopbusiness (#660)
    - tailscale (#620)
    - zoomoutlookplugin (#656)
    - zotero (#634)
    - zulujdk18 (#612)

- updated labels:
    - acroniscyberprotectconnectagent (#678)
    - adobecreativeclouddesktop (#687)
    - adobereaderdc-update (#707)
    - audacity (#708)
    - duckduckgo (#704)
    - libreoffice (#605)
    - nudge
    - obs (#692)
    - r (#702)
    - rstudio (#702)
    - screamingfrogseospider (#665)
    - vlc (#705, #606)
    - xcreds



## v10beta2

- fixed problem with GitHub labels (#659)
- bz2 archive support (#659)
- fixed WorkspaceOne support (#653)
- updated how `aapNewVersion` is determined (#680)

Plus everything from v10beta1

- new labels:
	- abetterfinderrename11 (#552)
	- carboncopycloner (#553)
	- cocoapods (#659)
	- coconutbattery (#588)
	- cricutdesignspace (#562)
	- dynalist (#591)
	- fellow (#591)
	- flexoptixapp (#554)
	- googleadseditor (#652, #541)
	- kap (#568)
	- keepingyouawake (#549)
	- lcadvancedvpnclient (#584)
	- masv (#569)
	- merlinproject (#555)
	- mongodbcompass (#654)
	- netspot (#556)
	- relatel (#619)
	- sonicvisualiser (#575)
	- strongdm (#559)
	- synologyassistant (#557)
	- synologydriveclient (#582)
	- tencentmeeting (#570)
	- typinator (#583)
	- xcreds (#675)
- updated labels:
	- acroniscyberprotectconnect/remotix (#664)
	- acroniscyberprotectconnectagent/remotixagent (#664)
	- awsvpnclient (#586)
	- boxtools (#589)
	- clevershare2 (#664)
	- coderunner (#664)
	- colourcontrastanalyser (#664)
	- cryptomator (#664)
	- dangerzone (#664)
	- drawio (#664)
	- golang (#664)
	- icons (#664)
	- insomnia (#664)
	- knockknock (#664)
	- libreoffice (#672)
	- macports
	- opera (#664)
	- supportapp (#664)
	- vmwarehorizonclient (#645, #511)
- deleted/deactivated labels:
	- microsoftyammer (#664)
	- wickrme (#664)
	- wickrpro (#664)


## v10beta1

- [swiftDialog](https://github.com/bartreardon/swiftDialog) integration (#641, #632), many thanks to @bartreardon, [sample scripts](in the MDM folder)
- added WorkspaceOne option for LOGO (#517)
- added function for JSON parsing with JXA (#529)
- updated assemble.sh script to update Labels.txt when script is rebuilt (#540)
- added a no requisite install script (#493)
- GitHub lookup now don't use API calls, this should avoid or at least reduce rate limiting (#543)
- fixed redundant exit codes (#643, #561)

NOTE: some exit codes have changed! see [Installomator Exit Codes](https://github.com/Installomator/Installomator/wiki/Installomator-Exit-Codes) for a list

- new labels:
	- bluejeanswithaudiodriver (#473)
	- duodevicehealth (#548)
	- googlechromeenterprise (#532)
	- ipswupdater (#545)
	- mmhmm (#571)
	- nordlayer (#419)
	- prune (#538)
	- whatroute (#560)
- updated labels:
	- blender (#535, #622)
	- camtasia2019 (#547)
	- clickshare (#565)
	- egnyte (#500)
	- googledrive (#563)
	- grammarly (#576)
	- marathon, marathon2, marathoninfinity (#544)
	- miro (#475, #539)
	- notion (#566)
	- ringcentralapp (#550)
	- sublimetext (#593, #578, #567, #623, #626)
	- talkdeskcallbar (#536)
	- talkdeskcxcloud (#537)
	- wireshark (#585)


## v9.2

**Note**: Both Google and Mozilla recommend using the pkg installers instead of the dmg downloads for managed deployments. So far, Installomator has provided labels for both. (`googlechrome` and `googlechromepkg` or `firefox` and `firefoxpkg`, respectively) Since there are problems with the dmg downloads, a future release of Installomator will _disable_ the `firefox` and `googlechrome` dmg labels. You should switch to using `googlechromepkg` and `firefoxpkg` labels instead.

- bug fix (#434)
- documentation updates (#485, #494)
- new labels:
    - 1password8 (#514)
	- ultimakercura
	- androidstudio (#547)
	- atextlegacy (#464)
	- camtasia2019, camtasia2020 (#499)
	- clue, cluefull (#481)
	- craftmanagerforsketch
	- displaylinkmanager (#448)
	- drawio (#480)
	- duckduckgo
	- egnytewebedit (#512)
	- filezilla (#522)
	- firefoxpkg_intl
	- flycut (#501)
	- fontexplorer (#523)
	- hype (#524)
	- idrive (#507), idrivethin (#509)
	- imageoptim (#525)
	- linear (#519)
	- macoslaps (#502)
	- mightymike
	- mindmanager (#479)
	- pika (#526)
	- propresenter7 (#394)
	- qgis-pr
	- shottr (#516)
	- slab (#487)
	- snagit2019, snagit2020, snagit2021 (#498)
	- sonobus (#490)
	- talkdeskcxcloud (#452)
	- thunderbird_intl (#497)
	- unnaturalscrollwheels (#503)
	- wechat (#510)
	- xeroxworkcentre7800 (#527)
	- zohoworkdrivegenie
- updated labels
	- adobereaderdc-update, adobereaderdc (#503)
	- amazoncorretto8jdk (#461)
	- camtasia (#499)
	- citrixworkspace (#508)
	- dbeaverce (#450)
	- dropbox
	- firefox, firefox_da, firefox_intl (#495), firefoxesr_intl (#496), firefoxpkg
	- googlechrome, googlechromepkg (#484)
	- gpgsuite (#465)
	- grammarly (#515)
	- logitechoptions (#478)
	- onlyofficedesktop (#454)
	- postman (#458)
	- rancherdesktop (#463)
	- remotedesktopmanagerenterprise
	- remotedesktopmanagerfree
	- ringcentralapp (#492)
	- sketch
	- snagit (#498)
	- talkdeskcallbar (#453)



## v9.1


- added option for Microsoft Endpoint Manager (Intune) to `LOGO` (#446)
- minor fixes (#427, #434, #436)
- the `googlechrome` label now always downloads the universal version (#430)
- new labels:
    - 1passwordcli (#429)
    - amazoncorretto8jdk (#423)
    - autodeskfusion360admininstall (#447)
    - axurerp10 (#439)
    - calcservice (#426)
    - clipy (#412)
    - dockutil (#432)
    - easyfind (#426)
    - grammarly (#444)
    - houdahspot (#426)
    - macadminspython (#431)
    - microsoftazuredatastudio (#438)
    - nanosaur (#426)
    - tembo (#426)
    - wordservice (#426)
    - xmenu (#426)
- updated labels:
    - appcleaner (#428)
    - dialog (#435, #437)
    - googlechrome (#430)
    - microsoftdefender (#440)
    - supportapp (#426)
    - zoom and zoomgov (#426, #433)



## v9.0.1

- improved logging levels throughout the script #408
- fixed a bug for `pkgindmg` style labels #408
- changed the criteria used to locate an app in the case the it cannot be found in the default locations, this should help with some apps with similar name (Virtual Box and Box Drive, #401) #413
- new label: WhiteBox Packages (`packages`) #415
- modified label: `loom` (added Apple silicon download) #417

## v9

- We have moved the root check to the beginning of the script, and improved DEBUG handling with two different modes. `DEBUG=0` is still for production, and `1` is still for the DEBUG we previously knew downloading to the directory it is running from, but `2` will download to temporary folder, will detect updates, but will not install anything, but it will notify the user (almost as running the script without root before).
- Added option to not interrupt Do Not Disturb full screen apps like Keynote or Zoom with `INTERRUPT_DND="no"`. Default is `"yes"` which is how it has worked until now.
- `pkgName` in a label can now be searched for. An example is logitechoptions, where only the name of the pkg is given, and not the exact file path to it.
- `LSMinimumSystemVersion` will now be honered, if the `Info.plist` in the app is specifying this. That means that an app that has this parameter in that file and it shows that the app requires a newer version of the OS than is currently installed, then we will not install it.
- New variable `RETURN_LABEL_NAME`. If given the value `1`, like `RETURN_LABEL_NAME=1` then Installomator only returns the name of the label. It makes for a better user friendly message for displaying in DEPNotify if that is integrated.
- Changed logic if `IGNORE_APP_STORE_APPS=yes`. Before this version a label like `microsoftonedrive` that was installed from App Store, and that we want to replace with the “ordinary” version, Installomator would still use `updateTool`, even though `IGNORE_APP_STORE_APPS=yes`. So we would have to have `INSTALL=force` in order to have the app replaced, as `updateTool` would be used. But now if `IGNORE_APP_STORE_APPS=yes` then `updateTool` will be not set, and the App Store app will be replaced. BUT if the installed software was not from App Store, then `updateTool` will not be used, and it would be a kind of a forced install (in the example of `microsoftonedrive`), except if the version is the same (where installation is skipped).
- Added variable `SYSTEMOWNER` that is used when copying files when installing. Default `0` is to change owner of the app to the current user on the Mac, like this user was installing this app themselves. When using `1` we will put “root:wheel” on the app, which can be useful for shared machines.
- Added option `curlOptions` to the labels. It can be filled with extra headers need for downloading the specific software. It needs to be an array, like `curlOptions=( )`. See “mocha”-software-labels.

Big changes to logging:
- Introducing variable `LOGGING`, that can be either of the logging levels
- Logging levels:
    0: DEBUG     Everything is logged
    1: INFO      Normal logging behavior
    2: WARN
    3: ERROR
    4: REQ
- External logging to Datadog
- A function to shorten duplicate lines in installation logs or output of longer commands
- Ability to extract install.log in the time when Installomator was running, if further investigations needs to be done to logs

Fixes:
- Fixed a problem with pkgs: If they were mounted with .pkg in the name, then we would find the directory and not the pkg file itself.
- Minor fix for a check for a pkgName on a DMG. We used `ls` that would throw an error when not found, so the check was corrected.

## v8.0

- removed leading `0` from the version because it has lost all meaning (thanks to @grahampugh for the inspiration)
- Installomator now detects when an app is already installed, and will display notifications correctly the user based on if the app was updated or installed for the first time.
- New variables for labels that should be installed using CLI: `CLIInstaller` and `CLIArguments`. When the installer app is named differently than the installed app, then the variable `installerTool` should be used to name the app that should be located in the DMG or zip. See the label __adobecreativeclouddesktop__ to see its use.
- `buildLabel.sh` has been improved to build GitHub software labels much easier. In essense if the URL contains github.com, then it will try to find if it's the latest version or if variable `archiveName` is needed for finding the software. Also improved messaging throughout the script, as well as handling a situation where a pkg does not include a “Distribution” file, but a “PackageInfo”.
- MDM script extended with `caffeinate` so Mac will not go to sleep during the time it takes installomator to run. Especially during setup, this can be useful.
- Microsoft labels with `updateTool` variable, is updated to run `msupdate --list` before running the updateTool directly. Problems have been reported that the update would fail if the `--list` parameter for the command was not run first. This should help with the Jamf agent stalling during installation.
- Added bunch of new labels, and improved others.

## v0.7

- default for `BLOCKING_PROCESS_ACTION`is now `BLOCKING_PROCESS_ACTION=tell_user` and not `prompt_user`. It will demand the user to quit the app to get it updated, and not present any option to skip it. In considering various use cases in different MDM solutions this is the best option going forward. Users usually choose to update, and is most often not bothered much with this information. If it's absoultely a bad time, then they can move the dialog box to the side, and click it when ready.
- script is now assembled from fragments. This helps avoid merging conflicts on git and allows the core team to work on the script logic while also accepting new labels. See the "Assemble Script ReadMe" for details.
- We now detect App Store installed apps, and we do not replace them automatically. An example is Slack that will loose all settings if it is suddenly changed from App Store version to the "web" version (they differ in the handling of settings files). If `INSTALL=force` then we will replace the App Store app. We log all this.
- Change in finding installed apps. We now look in /Applications and /Applications/Utilities first. If not found there, we use spotligt to find it. (We discovered a problem when a user has Parallels Windows installed with Microsoft Edge in it. Then Installomator wanted to update the app all the time, becaus spotlight found that Windows version of the app that Parallels created.)
- Added bunch of new labels, and improved others.
- Renamed `buildCaseStatement.sh` to `buildLabel.sh` and improved it a lot. It is a great start when figuring out how to create a new label for an app, or a piece of software. Look at the tutorials in our wiki.
- Mosyle changed their app name from Business to Self-Service

## v0.6 - 2021-07-14

- several new and updated labels, for a total of 302
- versionKey variable can be used to choose which Info.plist key to get the version from
- an appCustomVersion() {} function can now be used in a label
- with INSTALL=force, the script will not be using updateTool, but will reinstall instead
- added quit and quit_kill options to NOTIFY
- updated buildCaseStatement.sh
- updated buildInstallomatorPkg.sh to use notarytool (requires Xcode 13)
- several minor fixes

## v0.5 - 2021-04-13

- Major update and now with help from @Theile and @Isaac
- Added additional `BLOCKING_PROCESS_ACTION` handlings
- Added additional `NOTIFY=all`. Usuful if used in Self Service, as the user will be notified before download, before install as well as when it is done.
- Added variable `LOGO` for icons i dialogs, use `LOGO=appstore` (or `jamf` or `mosyleb` or `mosylem` or `addigy`). It's also possible to set it to a direct path to a specific icon. Default is `appstore`.
- Added variable `INSTALL` that can be set to `INSTALL=force` if software needs to be installed even though latest version is already installed (it will be a reinstall).
- Version control now included. The variable `appNewVersion` in a label can be used to tell what the latest version from the web is. If this is not given, version checking is done after download.
- For a label that only installs a pkg without an app in it, a variable `packageID` can be used for version checking.
- Labels now sorted alphabetically, except for the Microsoft ones (that are at the end of the list). A bunch of new labels added, and lots of them have either been changed or improved (with `appNewVersion` og `packageID`).
- If an app is asked to be closed down, it will now be opened again after the update.
- If your MDM cannot call a script with parameters, the label can be set in the top of the script.
- If your MDM is not Jamf Pro, and you need the script to be installed locally on your managed machines, then take a look at [Theiles fork](https://github.com/Theile/Installomator/). This fork can be called from the MDM using a small script.
- Script `buildCaseStatement.sh` to help with creating labels have been improved.
- Fixed a bug in a variable name that prevented updateTool to be used
- added `type` variable for value `"updateronly"` if the label should only run an updater tool.


## v0.4 - 2020-10-19

- you can now set script variables as an argument in the form `VARIABLE=value`. More detail on this in the README file, 'Configuration from Arguments.' (#26, #50, #72, and #73)
- change `downloadFromGit` to match file types better (#58)
- implemented a workaround for changed behavior of `xpath` in Big Sur (#80)
- added an option `prompt_user_then_kill` to `BLOCKING_PROCESS_ACTION` which will kill the process after the third unsuccessful attempt to quit (#78, thanks Patrick Atoon @raptor399)
- added several new labels for total of 116


## v0.3 - 2020-07-23

- added several new labels for total of 98
- removed the powershell labels, since the installer is not notarized
- when run without any arguments, the script now lists all labels
- changed how zips are expanded because this was broken on Mojave
- improved logging in some statements
- several more minor improvements


## v0.2 - 2020-06-09

- many fixes for broken URLs and other bugs
- the `pkgInDmg` and `pkgInZip` now search for a pkg file in the archive in case the file name varies with the version
- notification on successful installation can be suppressed with the `NOTIFY` variable
- Apple signed installers and apps that don’t have a Team ID are verified correctly now
improved logging
- several new applications: count increased from 62 in 0.1 to 87 in 0.2


## v0.1 - 2020-05-12
