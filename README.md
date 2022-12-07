# Note: The main repo is a beta version

Please locate “Releases” on the right, and download the latest 9.2 release (either pkg or zip) for a supported release. 

# Installomator

_The one installer script to rule them all._

![](https://img.shields.io/github/v/release/Installomator/Installomator)&nbsp;![](https://img.shields.io/github/downloads/Installomator/Installomator/latest/total)&nbsp;![](https://img.shields.io/badge/macOS-10.14%2B-success)&nbsp;![](https://img.shields.io/github/license/Installomator/Installomator)

This script is in the “we find it useful, it is working for us” stage.

Your production and deployment environment will be different, please test thoroughly before rolling it out to your production.

We have put a lot of work into making it stable and safe, but we cannot - of course - make _any_ promises that it won't break in some not yet encountered edge case.

## Authors

Intallomator was originally inspired by the download scripts from William Smith and Sander Schram, and created by:
- [Armin Briegel - @scriptingosx](https://github.com/scriptingosx)

Later on a few more members came on the project:
- Isaac Ordonez - @issacatmann
- [Søren Theilgaard - @Theile](https://github.com/Theile)
- [Adam Codega - @acodega](https://github.com/acodega)

 And with numerous contributions from many others.

## Support and Contributing

__Please note, that if you are contributing to this project with new labels or other suggestions in PRs, please put your changes in the files below `fragments`-folder. DO NOT edit the full `Installomator.sh` script. The full script is now a build of the fragments, and will be overwritten. See the [README.md](utils/README.md) file in the `utils` directory for detailed instructions.__

Discussion, support and advice around Installomator happens in the `#installomator` channel in the [MacAdmins.org Slack](https://macadmins.org). Go there for support questions.

Do not create an issue just when you have a questions, but do file an issue or pull request (PR) for bugs or wrong behavior. When in doubt, ask in the above Slack channel.

Please see [CONTRIBUTING.md](https://github.com/Installomator/Installomator/blob/dev/CONTRIBUTING.md) for how to contribute.

## More reading

Our wiki:

- [Wiki](https://github.com/Installomator/Installomator/wiki)

There are a few interesting post on Installomator on Armin’s weblog:

- [Introducing Installomator](https://scriptingosx.com/2020/05/introducing-installomator/)
- [Using Installomator with Jamf Pro](https://scriptingosx.com/2020/06/using-installomator-with-jamf-pro/) by Mischa van der Bent

## Background

In the world of managing Apple Macs, organizations can have two different approaches to the management. Either the IT department will tightly manage and verify each piece of software, or they will just want the latest software to be deployed as fast as possible.

OK, maybe some software should be tightly managed and others not, but you get the point.

### Tightly managed

If your solution needs to be tightly managed, i.e. the versions of the operating system and third party software are controlled and updates will only be pushed with the management system when the administration and security team went through an approval process and then the update is automated. This is an important and valid workflow and the right fit for many deployments.

Installomator was _not_ written for these kinds of deployment.

If you are running this kind of deployment, you want to use [AutoPkg](https://github.com/autopkg/autopkg) and you can stop reading here.

### Latest version always

There are other kinds of deployments, though. In these deployments the management system is merely used to “get the user ready” as quickly as possible when they set up a new machine, and to offer software from a self service portal. In these deployments, system and software installations are ‘latest version available’ and updates are user driven (though we do want to nag them and push them).

Installomator can help with this.

These deployments can be

- user driven
- low control
- minimal maintenance effort
- latest version is best

These can be 'user controlled' Macs and we (the admins) just want to assist the user in doing the right thing. And the right thing is (often) to install the latest versions and updates when they are available.

The Mac App Store and software pushed through the Mac App Store follow this approach. When you manage and deploy software through the App Store — whether it is on iOS or macOS — neither the MacAdmin nor the user get a choice of the application version. They will get the latest version.

In such deployments, keeping the installers hosted in your management system up to date is an extra burden. AutoPkg can, well, automate much of the download/re-package/upload/stage cycle, but it still requires oversight and maintenance. Instead of downloading, re-packaging, uploading application installers to the management system, it is often easier to run a script which downloads the latest version directly from the vendor's servers and installs it.

There are obviously a few downsides to this approach:

- when your fleet is mostly on site and many will install or update at the same time, they will reach out over the internet to the vendor's servers, possibly overwhelming your internet connection
- when you download software from the internet, it should be verified to avoid man-in-the-middle or other injection attacks
- there is no control over which version the clients get, you cannot "hold back" new versions for testing and approval workflows
- some application downloads are gated behind logins or paywalls and cannot be automated this way

Some of these disadvantages can be seen as advantages in different setups. When your fleet is mostly mobile and offsite, then downloading from vendor servers will relieve the inbound connection to your management server, or the data usage on your management system's cloud server. Software vendors are pushing for subscriptions with continuous updates and feature releases, so moving the entire team to the latest versions quickly can make those available quickly. Also being on the latest release includes all current security patches.

Because this is an attractive solution for _certain kinds_ of deployment, there are already many scripts out there that will download and install the latest version of a given software. And we have built and used quite a few in-house, as well. Most importantly, [William Smith has this script](https://gist.github.com/talkingmoose/a16ca849416ce5ce89316bacd75fc91a) which can be used to install several different Microsoft applications and bundles, because Microsoft has a nice unified URL scheme.

At some point, in 2018, Armin got frustrated at the number of scripts he was maintaining (or failing to). Also, his concern that most of the scripts weren’t doing _any_ verification of the download was getting unbearable. So, he set out to write _the one install script to rule them all…_

### Locally installed

So Armin made the version for Jamf Pro but universally for any MDM to adopt.

Søren looked at this, and wanted this approach to work in Mosyle and Addigy, and for these solutions we need Installomator to be locally installed on the Mac, and then the MDM can call this script from their scripts features. For some time Søren had a version of Installomator that was supplied with a notarized pkg, so it could be deployed as part of DEP or however was needed.

This has now been merged into Installomator, and with contributions of Isaac and Adam, new features and labels have been added more frequently.

## Goals

The goals for Installomator are:

- work with various common archive types
- verify the downloaded archive or application
- have a simple ‘interface’ to the admin
- single script file so it can ‘easily’ be copied into a management system
- signed and notarized pkg-installer for local installation
- extensible without deep scripting knowledge
- work independently of a specific management system
- no dependencies that may be removed from macOS in the future or are not pre-installed

In Detail:

### Archive types

Installomator can work with the following common archive and installer types:

- pkg: as a direct download, or when nested inside a dmg or zip
- dmg: for the common 'drag app to /Applications' installation style
- zip: the application is just compressed with zip or or tbz

When the download yields a pkg file, Installomator will run `installer` to install it on the current system.

Applications in dmgs or zips will be copied to `/Applications` and their owner will be set to the current user, so the install works like a standard drag'n drop installation. Owner can also be set to root/wheel.

(I consider it a disgrace, that Jamf, after nearly 20 years, _still_ cannot deal with ‘drag’n drop installation dmgs natively. It’s not _that_ hard.)

### Verify the download

I chose to use the macOS built-in verification for the downloads. Even though download quarantine does usually not take effect with scripted downloads and installations, we _can_ use Gatekeeper's verification with the `spctl` command.

All downloads have to be signed _and_ notarized by a valid Apple Developer ID. Signature and notarization will verify the origin and that the archive has not been tampered with in transfer. In addition, the script compares the developer team ID (the ten-digit code associated with the Apple Developer account) with the _expected_ team ID, so that software signed with a different, malicious Apple ID will not be installed.

### Simple interface

When used to install software, Installomator has a single argument: the label or name of the software to be installed.

```
./Installomator.sh firefox
./Installomator.sh firefox LOGO=jamf BLOCKING_PROCESS_ACTION=tell_user_then_kill NOTIFY=all
```

There is a debug mode and other settings that can be controlled with variables in the code. This simplifies the actual use of the script from within a management system.

### Extensible

As of this writing, Installomator knows how to download and install more than 364 different applications. You can add more by adding new labels to the `fragments`-folder. Below is an example of a label, and most of them (just) needs this information (not really "just" in this case, as we have to differentiate between arm64 and i386 versions for both `downloadURL` and `appNewVersion`):

```
googlechrome)
    name="Google Chrome"
    type="dmg"
    if [[ $(arch) != "i386" ]]; then
        printlog "Architecture: arm64 (not i386)"
        downloadURL="https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"
        appNewVersion=$(curl -s https://omahaproxy.appspot.com/history | awk -F',' '/mac_arm64,stable/{print $3; exit}')
    else
        printlog "Architecture: i386"
        downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
        appNewVersion=$(curl -s https://omahaproxy.appspot.com/history | awk -F',' '/mac,stable/{print $3; exit}')
    fi
    expectedTeamID="EQHXZ8M8AV"
    ;;
```

When you know how to extract these pieces of information from the application and/or download, then you can add an application to Installomator.

The script `buildLabel.sh` can help with the label creation. Just server the URL to the script, and it will try to figure out things and write out a label as output. See [Wiki Tutorials](https://github.com/Installomator/Installomator/wiki#tutorials).

Please note: Labels should be named in small caps, numbers 0-9, “-”, and “_”. No other characters allowed.

Actually labels are part of a case-statement, and must be formatted accordingly.

### Not specific to a management system

Armin wrote this script mainly for use with Jamf Pro, because that is what he used. For testing, you can run the script interactively from the command line. However, we have tried to keep anything that is specific to Jamf optional, or so flexible that it will work anywhere. Even if it does not work with your management system ‘out of the box’, the adaptations should be straightforward.

Not all MDMs can include the full script, for those MDMs it might be more useful to install it on the client machines, and run it from there. So a PKG to be installed on client Macs is also provided here.

### No dependencies

The script started out as a pure `sh` script, and when arrays was needed it was ‘switched’ to `zsh`, because that is what [we can rely on being in macOS for the foreseeable future](https://scriptingosx.com/zsh). There are quite a few places where using python would have been easier and safer, but with the python 2 run-time being deprecated, that would have added a requirement for a Python 3 run-time to be installed. XML and JSON parsing would have been better with a tool like [scout](https://github.com/ABridoux/scout) or [jq](https://stedolan.github.io/jq/), but those would again require additional installations on the client before the script can run.

Keeping the script as a `zsh` allows you to paste it into your management system's interface (and disable the DEBUG mode) and use it without requiring any other installations.

## How to use

### Interactively in the command line

The script will require one argument.

The argument can be `version` or `longversion` which will print the script's version.

```
> ./Installomator.sh version
2021-03-28 10:03:42 version ################## Start Installomator v. 0.5.0
2021-03-28 10:03:42 version ################## version
2021-03-28 10:03:42 version 0.5.0
> ./Installomator.sh longversion
2021-03-28 10:04:16 longversion ################## Start Installomator v. 0.5.0
2021-03-28 10:04:16 longversion ################## longversion
2021-03-28 10:04:16 longversion Installomater: version 0.5.0 (2021-03-28)
```

Other than the version arguments, the argument can be any of the labels listed in the Labels.txt file. Each of the labels will download and install the latest version of the application, or suite of applications. Since the script will have to run the `installer` command or copy the application to the `/Applications` folder, it will have to be run as root.

```
> sudo ./Installomator.sh desktoppr DEBUG=0
```

(Since Jamf Pro always provides the mount point, computer name, and user name as the first three arguments for policy scripts, the script will use argument `$4` when there are more than three arguments.)

### Debug mode

There is a variable named `DEBUG` which is set in line 21 of the script. When `DEBUG` is set to `1` (default) or `2` for a variation of debug, no actions that would actually modify the current system are taken. This is useful for testing most of the actions in the script, but obviously not all of them.

When the `DEBUG` variable is `1`, downloaded archives and extracted files will be written to the script's directory, rather than a temporary directory, which can make debugging easier.

When `DEBUG` variable is `2`, the temporary folder is created and downloaded and extracted files goes to that folder, as if not in DEBUG mode, but installation is still not done. On the other hand blocking processes are checked, the app is reopened if closed, and the user is notified.

Debug mode 1 is useful to test the download and verification process without having to re-download and re-install an application or package on your system. Debug mode 2 is great for checking running processe and notifications.

_Always remember_ to change the `DEBUG` variable to `0` when deploying. The installer PKG we provide has `DEBUG=0`.

### Use Installomator with various MDM solutions

In the wiki we have provided documentation on how Installomator is used in various MDM solution, like [Jamf Pro](https://github.com/Installomator/Installomator/wiki/MDM:-Jamf-Pro), [Mosyle](https://github.com/Installomator/Installomator/wiki/MDM:-Mosyle-(Business,-Fuse,-and-Manager)), and [Addigy](https://github.com/Installomator/Installomator/wiki/MDM:-Addigy).

## What it does

When it runs with a known label, the script will perform the following:

- Check the version installed with the version online. Only continue if it's different
- download the latest version from the vendor
- when the application is running, prompt the user to quit or cancel (customizable)
- dmg or zip archives:
    - extract the application and copy it to /Applications
    - change the owner of the application to the current user
- pkg files:
    - when necessary, extract the pkg from the enclosing archive
    - install the pkg with the `installer` tool
- clean up the downloaded files
- notify the user (also customizable)

## Configuring the script

We have several default settings for certain behavior and notifications inside the script, but these can be customized when calling the script.

### Blocking Process actions

The `BLOCKING_PROCESS_ACTION` variable controls the behavior of the script when it finds a blocking process running.

There are eight options:

- `ignore`: continue even when blocking processes are found.
- `silent_fail`: Exit script without prompt or installation.
- `prompt_user`: Show a user dialog for each blocking process found, user can choose "Quit and Update" or "Not Now". When "Quit and Update" is chosen, blocking process will be told to quit. Installomator will wait 30 seconds before checking again in case Save dialogs etc are being responded to. Installomator will abort if quitting after three tries does not succeed. "Not Now" will exit Installomator.
- `prompt_user_then_kill`: show a user dialog for each blocking process found, user can choose "Quit and Update" or "Not Now". When "Quit and Update" is chosen, blocking process will be terminated. Installomator will abort if terminating after two tries does not succeed. "Not Now" will exit Installomator.
- `prompt_user_loop`: Like prompt-user, but clicking "Not Now", will just wait an hour, and then it will ask again.
  WARNING! It might block the MDM agent on the machine, as the script will not exit, it will pause until the hour has passed, possibly blocking for other management actions in this time.
- `tell_user`: (Default) User will be showed a notification about the important update, but user is only allowed to Quit and Continue, and then we ask the app to quit. This is default.
- `tell_user_then_kill`: User will be showed a notification about the important update, but user is only allowed to Quit and Continue. If the quitting fails, the blocking processes will be terminated.
- `kill`: kill process without prompting or giving the user a chance to save.

If any process was closed, Installomator will try to open the app again, after the update process is done.

### Notification

The `NOTIFY` variable controls the notifications shown to the user. As of now, there are three options:

- `success`:   (default) notify the user after a successful install
- `silent`:    no notifications
- `all`:       all notifications (great for Self Service installation)

### Logo

The `LOGO` variable is used for the icon shown in dialog boxes. There are these options:

- `appstore`:    Icon is Apple App Store (default)
- `jamf`:        JAMF Pro
- `mosyleb`:     Mosyle Business
- `mosylem`:     Mosyle Manager (Education)
- `addigy`:      Addigy
Path can also be set in the command call, and if file exists, it will be used, like `LOGO="/System/Applications/App\ Store.app/Contents/Resources/AppIcon.icns"` (spaces are escaped).

### App Store apps handling
Default is `IGNORE_APP_STORE_APPS=no`
__options:__
- `no`: If installed app is from App Store (which include VPP installed apps) it will not be touched, no matter it's version (default)
- `yes`: Replace App Store (and VPP) version of app and handle future updates using Installomator, even if latest version. Shouldn’t give any problems for the user in most cases. Known bad example: Slack will loose all settings.

### Owner of copied apps
Default is `SYSTEMOWNER=0`
__options:__
- `0`: Current user will be owner of copied apps, just like if they installed it themselves (default).
- `1`: root:wheel will be set on the copied app. Useful for shared machines.

### Install behavior (force installation)

Since we now make a version checking, and only installs the software if the version is different, an `INSTALL` variable can be used to force the installation:

- ` `:           When not set, software is only installed if it is newer/different in version (default)
- `force`:       Install even if it’s the same version

### Re-opening of closed app

The `REOPEN` can be used to prevent the reopening of a closed app

- `yes`:   (default) app will be reopened if it was closed
- `no`:    app not reopened

### Configuration from Arguments

You can provide a configuration variable, such as `DEBUG` or `NOTIFY` as an argument in the form `VAR=value`. For example:

```
./Installomator.sh desktoppr DEBUG=0 NOTIFY=silent
```

Providing variables this way will override any variables set in the script.

You can even provide _all_ the variables necessary for download and installation. Of course, without a label the argument parsing will fail, so I created a special label `valuesfromarguments` which only checks if the four required values are present:

```
./Installomator.sh name=desktoppr type=pkg downloadURL=https://github.com/scriptingosx/desktoppr/releases/download/v0.3/desktoppr-0.3.pkg expectedTeamID=JME5BW3F3R valuesfromarguments
```

The order of the variables and label is not relevant. But, when you provide more than one label, all but the _last_ label will be ignored.

Providing all the variables this way might be useful for certain downloads that have a customized URL for each vendor/customer (like customized TeamView or Watchman Monitoring) or are local downloads.

## Adding applications/label blocks

### Required Variables

The script requires four pieces of information to download and install an application:

```
spotify)
    name="Spotify"
    type="dmg"
    downloadURL="https://download.scdn.co/Spotify.dmg"
    expectedTeamID="2FNC3A47ZF"
    ;;
```

The four required variables are

- `name`:
The display name of the installed application without the `.app` extensions.

- `type`:
The type of installation. Possible values:
     - `dmg`: application in disk image file (drag'n drop installation)
     - `pkg`: flat pkg download
     - `zip`: application in zip archive (`zip` extension)
     - `tbz`: application in tbz archive (`tbz` extension)
     - `pkgInDmg`: a pkg file inside a disk image
     - `pkgInZip`: a pkg file inside a zip
     - `appInDmgInZip`: an app in a dmg file that has been zip'ed

- `downloadURL`:
The URL from which to download the archive.
The URL can be generated by a series of commands, for example when you need to parse an xml file for the latest URL. (See `bbedit`, `desktoppr`, or `omnigraffle` for examples.)
Sometimes version differs between Intel and Apple Silicon versions. (See `brave`,  `obsidian`, `omnidisksweeper`, or `notion`).

- `curlOptions`: (array, optional)
Options to the `curl` command, needed for `curl` to be able to download the software.
Usually used for adding extra headers that some servers need in order to serve the file.
`curlOptions=( -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" )`
(See “mocha”-labels, for examples on labels, and `buildLabel.sh` for header-examples.)

- `appNewVersion` (optional, but recommended):
Version of the downloaded software.
If given, it will be compared to installed version, to see if download is different.
It does not check for newer or not, only different.
Not always easy to figure out how to make this. Sometimes this is listed on the downloads page, sometimes in other places. And how can we isolate it in a genral manner? (See `abstract`, `bbedit`, `brave`, `desktoppr`, `googlechrome`, or `omnidisksweeper`).

- `packageID` (optional, but recommended for pkgs without an app)
This variable is for pkg bundle IDs. Very usefull if a pkg only install command line tools, or the like that does not install an app. (See label `desktoppr`, `golang`, `installomator_st`, `odrive`, or `teamviewerhost`).

- `expectedTeamID`:
The 10-character Developer Team ID with which the application or pkg is signed and notarized.

  Obtain the team ID by running:

   - Applications (in dmgs or zips)
     `spctl -a -vv /Applications/BBEdit.app`

   - Installation Packages (pkg)
     `spctl -a -vv -t install ~/Downloads/desktoppr-0.2.pkg`

### Optional Variables

Depending on the application or pkg there are a few more variables you can or need to set. Many of these are derived from the required variables, but may need to be set manually if those derived values do not work.

- `archiveName`: (optional)
  The name of the downloaded file.
  When not given the `archiveName` is set to `$name.$type`

- `appName`: (optional)
  File name of the app bundle in the dmg to verify and copy (include the `.app`).
  When not given, the `appName` is set to `$name.app`.
  This is also the name of the app that will get reopned, if we closed any `blockingProcesses` (see further down)

- `targetDir`: (optional)
  dmg or zip:
    Applications will be copied to this directory.
    Default value is '`/Applications`' for dmg and zip installations.
  pkg:
    `targetDir` is used as the install-location. Default is '`/`'.

- `blockingProcesses`: (optional)
  Array of process names that will block the installation or update.
  If no `blockingProcesses` array is given the default will be:
    `blockingProcesses=( $name )`
  When a package contains multiple applications, _all_ should be listed, e.g:
    `blockingProcesses=( "Keynote" "Pages" "Numbers" )`
  When a workflow has no blocking processes, use
    `blockingProcesses=( NONE )`

- `pkgName`: (optional, only used for `dmgInPkg` and `dmgInZip`)
  File name of the pkg file _inside_ the dmg or zip.
  When not given the pkgName is set to `$name.pkg`.

- `updateTool`, `updateToolArguments`:
  When Installomator detects an existing installation of the application,
  and the `updateTool` variable is set then
     `$updateTool $updateArguments`
  Will be run instead of of downloading and installing a complete new version.
  Use this when the `updateTool` does differential and optimized downloads.
  e.g. `msupdate` (see various Microsoft installations).

- `updateToolRunAsCurrentUser`:
  When this variable is set (any value), `$updateTool` will be run as the current user. Default is unset and

- `CLIInstaller`:
- `CLIArguments`:
  If the downloaded dmg is actually an installer that we can call using CLI, we can use these two variables for what to call.
  We need to define `name` for the installed app (to be version checked), as well as `installerTool` for the installer app (if named differently that `name`. Installomator will add the path to the folder/disk image with the binary, and it will be called like this:
     `$CLIInstaller $CLIArguments`
  For most installations `CLIInstaller` should contain the `installerTool` for the CLI call (if it’s the same).
  We can support a whole range of other software titles by implementing this.
  See label adobecreativeclouddesktop.

- `installerTool`:
  Introduced as part of `CLIInstaller`. If the installer in the DMG or ZIP is named differently than the installed app, then this variable can be used to name the installer that should be located after mounting/expanding the downloaded archive.
  See label adobecreativeclouddesktop

## Frequently Asked Questions

### What if the latest version of the app is already installed?

Short answer: That depends on if labels will know what the latest version will be.

Longer answer:

- Labels without this will re-download and re-install the latest over the existing installation.
- Labels with this info will only install the app if the version is different than the one installed.
- Labels that can use update tool will use that for the update (if the version is different)

### Why don't you just use `autopkg install`?

Short answer: `autopkg` is not designed or suited for this kind of workflow

Long answer:

The motivation to not re-invent the wheel and use and existing tool is understandable. However, `autopkg` was not designed with this use case in mind and has a few significant downsides.

First, you would have to deploy and manage autopkg on all the clients. But to do its work, `autopkg` requires recipes. So, you have to install, and update the recipe repos on the client, as well. For security reasons, you _really_ should only run trusted recipes, so you need to install and update your personal recipe overrides as well.

The recipes you use are probably spread across multiple community provided recipe-repos, so we have `autopkg` itself, several recipe-repos, and your overrides that we need to manage, each of which may need to be updated at any time.

The community recipe-repos contain several recipes for different applications. When you add a recipe-repo for an app you want, you will also install all the other recipes from that repo.

The `autopkg install` does _not_ require root or even administrative privileges. _Any_ user (even standard users) on the system can now install any of the random recipes that came with the community repos.

To prevent users installing random apps from the community repos, you can curate your own recipe-repo from the community repos and push that to the clients. At this point, you are managing autopkg, your curated repo, your recipe overrides on the clients and handling the additional work of curating and updating your recipe-repo and the overrides.

In addition, a really savvy user (or a malicious attacker) could build their own recipe and run it using the pre-installed `autopkg` you installed.

And then consider what your CISO department (if you have one) would say about the `autopkgserver` and `autopkginstalld` daemons running on all the clients...

At this point it would be easier to use AutoPkg the way it was intended: on a single admin Mac, and let it upload the pkgs to your management system, which deploys them. Each tool is doing what it is designed for.

Please don't misunderstand this as me saying that AutoPkg is a bad or poorly designed tool. AutoPkg is amazing, powerful, and useful. The [Scripting OS X recipe-repo](https://github.com/autopkg/scriptingosx-recipes) is one of the older repos. AutoPkg is valuable tool to help admins with many apps that cannot be automated with tools like Installomator, and with deployment strategies that require more control.

But it is not suited as a client install automation tool.

### Why don't you just use brew or MacPorts?

Read the explanation for `autopkg`, pretty much the same applies for `brew`, i.e. while it is useful on a single Mac, it is a un-manageable mess when you think about deploying and managing on a fleet of computers.

