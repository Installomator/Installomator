# Installomator

_The one installer script to rule them all._The

![](https://img.shields.io/github/v/release/scriptingosx/Installomator)

## Background

As a system engineer at [an Apple Authorized Enterprise Reseller](https://prowarehouse.nl), we manage a lot of Jamf instances.

Some of these instances are tightly managed, i.e. the versions of the operating system and third party software are controlled and updates will only be pushed with the management system when the administration and security team went through an approval process and then the update is automated. This is an important and valid workflow and the right fit for many deployments.

Installomator was _not_ written for these kinds of deployment.

If you are running this kind of deployment, you want [AutoPkg](https://github.com/autopkg/autopkg).

There are other kinds of deployments, though. In these deployments the management system is merely used to "get the user ready" as quickly as possible when they set up a new machine, and to offer software from a self service portal. In these deployments, system and software installations are 'latest version available' and updates are user driven (though we do want to nag them).

These are mostly 'user controlled' Macs and we mostly just want to assist the user in doing the right thing. And the right thing is (often) to install the latest versions and updates when they are available.

The Mac App Store and software pushed through the Mac App Store follow this approach. When you manage software through the App Store — whether it is on iOS or macOS — neither the MacAdmin nor the user get a choice of the application version. They will get the latest version.

In such deployments, keeping the installers hosted in your management system up to date is an extra burden that often feels unnecessary. Instead of downloading, re-packaging, uploading application installers to the management system, it is often easier to run a script which downloads the latest version directly from the vendor's servers and installs it.

There are obviously a few downsides to this approach:

- when your fleet is mostly on site and many will install or update at the same time, they will reach out over the internet to the vendor's servers, possibly overwhelming your internet connection
- when you download software from the internet, it should be verified to avoid man-in-the-middle or other injection attacks
- there is no control over which version the clients get

Some of these disadvantages can be seen as advantages in different setups. When your fleet is mostly mobile and offsite, then downloading from vendor servers will relieve the inbound connection to your management server, or the data usage on your cloud server. Software vendors are pushing for subscriptions with continuous updates and feature releases, so moving the entire team to the latest versions quickly can make those available quickly. Also being on the latest release includes all current security patches.

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

Applications in dmgs or zips will be copied to `/Applications` and their owner will be set to the current user, so the install works like a standard drag'b drop installation.

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

## 




