# Installomator

_The one installer script to rule them all._

![](https://img.shields.io/github/v/release/scriptingosx/Installomator)&nbsp;![](https://img.shields.io/github/downloads/scriptingosx/Installomator/latest/total)&nbsp;![](https://img.shields.io/badge/macOS-10.14%2B-success)&nbsp;![](https://img.shields.io/github/license/scriptingosx/Installomator)

This script is in the "we find it useful, it is working for us" stage.

Your production and deployment environment will be different, please test thoroughly before rolling it out to your production.

I have put a lot of work into making it stable and safe, but I cannot - of course - make _any_ promises that it won't break in some not yet encountered edge case.


## Background

As a system engineer at [an Apple Authorized Enterprise Reseller](https://prowarehouse.nl), we manage a lot of Jamf instances.

Some of these instances are tightly managed, i.e. the versions of the operating system and third party software are controlled and updates will only be pushed with the management system when the administration and security team went through an approval process and then the update is automated. This is an important and valid workflow and the right fit for many deployments.

Installomator was _not_ written for these kinds of deployment.

If you are running this kind of deployment, you want to use [AutoPkg](https://github.com/autopkg/autopkg) and you can stop reading here.

There are other kinds of deployments, though. In these deployments the management system is merely used to "get the user ready" as quickly as possible when they set up a new machine, and to offer software from a self service portal. In these deployments, system and software installations are 'latest version available' and updates are user driven (though we do want to nag them).

These deployments are

- user driven
- low control
- minimal maintenance effort

These are mostly 'user controlled' Macs and we (the admins) just want to assist the user in doing the right thing. And the right thing is (often) to install the latest versions and updates when they are available.

The Mac App Store and software pushed through the Mac App Store follow this approach. When you manage and deploy software through the App Store — whether it is on iOS or macOS — neither the MacAdmin nor the user get a choice of the application version. They will get the latest version.

In such deployments, keeping the installers hosted in your management system up to date is an extra burden. AutoPkg can, well, automate much of the download/re-package/upload/stage cycle, but it still requires oversight and maintenance. Instead of downloading, re-packaging, uploading application installers to the management system, it is often easier to run a script which downloads the latest version directly from the vendor's servers and installs it.

There are obviously a few downsides to this approach:

- when your fleet is mostly on site and many will install or update at the same time, they will reach out over the internet to the vendor's servers, possibly overwhelming your internet connection
- when you download software from the internet, it should be verified to avoid man-in-the-middle or other injection attacks
- there is no control over which version the clients get, you cannot "hold back" new versions for testing and approval workflows
- some application downloads are gated behind logins or paywalls and cannot be automated this way

Some of these disadvantages can be seen as advantages in different setups. When your fleet is mostly mobile and offsite, then downloading from vendor servers will relieve the inbound connection to your management server, or the data usage on your management system's cloud server. Software vendors are pushing for subscriptions with continuous updates and feature releases, so moving the entire team to the latest versions quickly can make those available quickly. Also being on the latest release includes all current security patches.

Because this is an attractive solution for _certain kinds_ of deployment, there are already many scripts out there that will download and install the latest version of a given software. And we have built and used quite a few in-house, as well. Most importantly, [William Smith has this script](https://gist.github.com/talkingmoose/a16ca849416ce5ce89316bacd75fc91a) which can be used to install several different Microsoft applications and bundles, because Microsoft has a nice unified URL scheme.

At some point, earlier this year, I got frustrated at the number of scripts we were maintaining (or failing to). Also, my concern that most of the scripts weren't doing _any_ verification of the download was getting unbearable. So, I set out to write the one install script to rule them all...

## Goals

My goals for Installomator are:

- work with various common archive types
- verify the downloaded archive or application
- have a simple 'interface' to the admin
- single script file so it can 'easily' be copied into a management system
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

Applications in dmgs or zips will be copied to `/Applications` and their owner will be set to the current user, so the install works like a standard drag'n drop installation.

(I consider it a disgrace, that Jamf, after nearly 20 years, _still_ cannot deal with 'drag'n drop installation dmgs' natively. It's not _that_ hard.)

### Verify the download

I chose to use the macOS built-in verification for the downloads. Even though download quarantine does usually not take effect with scripted downloads and installations, we _can_ use Gatekeeper's verification with the `spctl` command.

All downloads have to be signed _and_ notarized by a valid Apple Developer ID. Signature and notarization will verify the origin and that the archive has not been tampered with in transfer. In addition, the script compares the developer team ID (the ten-digit code associated with the Apple Developer account) with the _expected_ team ID, so that software signed with a different, malicious Apple ID will not be installed.

### Simple interface

When used to install software, Installomator has a single argument: the label or name of the software to be installed.

```
./Installomator.sh firefox
```

There is a debug mode and one other setting that can be controlled with variables in the code. This simplifies the actual use of the script from within a management system.

### Extensible

As of this writing, Installomator knows how to download and install more than 50 different applications. You can add more by adding a block to the _long_ `case` statement starting on line 160. Some of them are more elaborate, but most of them just need this information:

```
    googlechrome)
        name="Google Chrome"
        type="dmg"
        downloadURL="https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
        expectedTeamID="EQHXZ8M8AV"
        ;;
```

When you know how to extract these pieces of information from the application and/or download, then you can add an application to Installomator.

### Not specific to a management system

I wrote this script mainly for use with Jamf Pro, because that is what we use. For testing, you can run the script interactively from the command line. However, I have tried to keep anything that is specific to Jamf optional, or so flexible that it will work anywhere. Even if it does not work with your management system 'out of the box,' the adaptations should be straightforward.

### No dependencies

The script started out as a pure `sh` script, and when I needed arrays I 'switched' to `zsh`, because that is what [we can rely on being in macOS for the foreseeable future](https://scriptingosx.com/zsh). There are quite a few places where using python would have been easier and safer, but with the python 2 run-time being deprecated, that would have added a requirement for a Python 3 run-time to be installed. XML and JSON parsing would have been better with a tool like [scout](https://github.com/ABridoux/scout) or [jq](https://stedolan.github.io/jq/), but those would again require additional installations on the client before the script can run.

Keeping the script as a `zsh` allows you to paste it into your management system's interface (and disable the DEBUG mode) and use it without requiring any other installations.

## How to use

### Interactively in the command line

The script will require one argument.

The argument can be `version` or `longversion` which will print the script's version.

```
> ./Installomator.sh version
0.1
> ./Installomator.sh longversion
Installomater: version 0.1 (20200506)
```

Other than the version arguments, the argument can be any of the labels listed in the Labels.txt file. Each of the labels will download and install the latest version of the application, or suite of applications. Since the script will have to run the `installer` command or copy the application to the `/Applications` folder, it will have to be run as root.

```
> sudo ./Installomator.sh desktoppr
```

(Since Jamf Pro always provides the mount point, computer name, and user name as the first three arguments for policy scripts, the script will use argument `$4` when there are more than three arguments.)

### Debug mode

There is a variable named `DEBUG` which is set in line 21 of the script. When `DEBUG` is set to `1` (default) no actions that would actually modify the current system are taken. This is useful for testing most of the actions in the script, but obviously not all of them.

Also when the `DEBUG` variable is `1`, downloaded archives and extracted files will be written to the script's directory, rather than a temporary directory, which can make debugging easier.

_Always remember_ to change the `DEBUG` variable to `0` when deploying.

### Use Installomator with Jamf Pro

In Jamf Pro, create a new 'Script' and paste the contents of `Installomator.sh` into the 'Script Contents' area. Under 'Options' you can change the parameter label for argument 4 to 'Application Label.'

Remember to set `DEBUG` to `0`.

Then you can use the Installomator script in a policy and choose the application to install by setting the label for argument 4.

## What it does

When it runs with a known label, the script will perform the following:

- when the application is running, prompt the user to quit or cancel
- download the latest version from the vendor
- dmg or zip archives:
    - extract the application and copy it to /Applications
    - change the owner of the application to the current user
- pkg files:
    - when necessary, extract the pkg from the enclosing archive
    - install the pkg with the `installer` tool
- clean up the downloaded files
- notify the user

## Configuring the script

As of now there are two settings that are meant to configured when deploying the script.

### Debug mode

The first is the `DEBUG` variable. When this is set to `1` the script will _not_ perform any changes to the current system. In other words, no application will be copied to the target directory and no `installer` command be performed.

In addition, files will be downloaded and extracted to the Installomator project folder instead of a temporary directory and _not_ deleted when the script exits. Also archives will _not_ be re-downloaded when they already exist in the project folder. The repository's `.gitignore` file is set up to ignore the archive file extensions.

Debug mode is useful to test the download and verification process without having to re-download and re-install an application or package on your system.

### Blocking Process actions

The `BLOCKING_PROCESS_ACTION` variable controls the behavior of the script when it finds a blocking process running.

There are four options:

- `ignore`:       continue even when blocking processes are found
- `silent_fail`:  exit script without prompt or installation
- `prompt_user`:  show a user dialog for each blocking process found abort after three attempts to quit
- `kill`:         kill process without prompting or giving the user a chance to save

The default is `prompt_user`.

### Adding applications/label blocks

#### Required Variables

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
     - `zip`: application in zip archive (`zip` or `tbz` extension)
     - `pkgInDmg`: a pkg file inside a disk image
     - `pkgInZip`: a pkg file inside a zip

- `downloadURL`:
The URL from which to download the archive.
The URL can be generated by a series of commands, for example when you need to parse an xml file for the latest URL. (See `bbedit`, `desktoppr`, or `omnigraffle` for examples.)

- `expectedTeamID`:
The 10-character Developer Team ID with which the application or pkg is signed and notarized.

  Obtain the team ID by running:

   - Applications (in dmgs or zips)
     `spctl -a -vv /Applications/BBEdit.app`

   - Pkgs
     `spctl -a -vv -t install ~/Downloads/desktoppr-0.2.pkg`


#### Optional Variables

Depending on the application or pkg there are a few more variables you can or need to set. Many of these are derived from the required variables, but may need to be set manually if those derived values do not work.

- `archiveName`: (optional)
  The name of the downloaded file.
  When not given the `archiveName` is set to `$name.$type`

- `appName`: (optional)
  File name of the app bundle in the dmg to verify and copy (include the `.app`).
  When not given, the `appName` is set to `$name.app`.

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
  e.g. `msupdate` (see microsoft installations)

- `updateToolRunAsCurrentUser`:
  When this variable is set (any value), `$updateTool` will be run as the current user. Default is unset and 

## Frequently Asked Questions

### What if the latest is already installed?

Short answer: Installomator will re-download and re-install the latest over the existing installation.

Longer answer:

Installomator will try to find a currently installed app and log the version. When Installomator finds an existing app (any version) and the `updateTool` variable is set, then Installomator will _not_ download and install, but run the `updateTool` instead.

However, there is no simple generic method to actually determine the latest version of an application or installer.

We deploy Installomator usually for user initiated installations from Self Service, so re-installs don't really 'hurt' and may be a useful troubleshooting step.

When you want to have automated installations, you should use smart groups based on the app version to limit excessive re-installations.

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

### Why don't you just use brew?

Read the explanation for `autopkg`, pretty much the same applies for `brew`, i.e. While it is useful on a single Mac, it is a un-manageable mess when you think about deploying and managing on a fleet of computers.

