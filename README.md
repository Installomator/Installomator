
# Installomator

_The one installer script to rule them all._

![](https://img.shields.io/github/v/release/Installomator/Installomator)&nbsp;![](https://img.shields.io/github/downloads/Installomator/Installomator/latest/total)&nbsp;![](https://img.shields.io/badge/macOS-10.14%2B-success)&nbsp;![](https://img.shields.io/github/license/Installomator/Installomator)

**Important:** The default (`main`) branch is a beta version of the next release. It contains the latest fixes, new labels and changes to application labels, but they are also not thoroughly tested yet. Installomator is designed so that changes to application labels should not affect the behavior of the script outside of that label, so it should be mostly safe, but things may be in flux. If you want the latest release version, you can either switch to the [`release` branch](https://github.com/Installomator/Installomator/tree/release) from the branch menu above the file list (where is says 'main' by default) or download the Installomator latest, non-beta, zip from the ['Releases'](https://github.com/Installomator/Installomator/releases) area and extract Installomator.sh. [More detail on the wiki.](https://github.com/Installomator/Installomator/wiki/Branches-and-Betas)

**Always test carefully and thoroughly in your environment before going to production!**

*Every production and deployment environment is different: please test thoroughly before rolling it out to your production.*

We have put a lot of work into making it stable and safe, but we _cannot_ and will not make _any_ promises that it won't break in some not yet encountered edge case.

## Support and Contributing

__Please note, that if you are contributing to this project with new labels or other suggestions in PRs, please put your changes in the files in the `fragments`-folder. DO NOT edit the full `Installomator.sh` script. The full script is assembled from the fragment files for release, and will be overwritten. See the [README.md](utils/README.md) file in the `utils` directory for detailed instructions.__

Discussion, support and advice around Installomator happens in the `#installomator` channel in the [MacAdmins.org Slack](https://macadmins.org). Please go there for support questions. Do not create an issue just when you have a questions, but do file an issue or pull request (PR) for bugs or wrong behavior. When in doubt, ask in the above Slack channel.

Please see [CONTRIBUTING.md](https://github.com/Installomator/Installomator/blob/dev/CONTRIBUTING.md) for how to contribute.

## Installomator Wiki

- [Wiki](https://github.com/Installomator/Installomator/wiki)
- [Motivation and Background](https://github.com/Installomator/Installomator/wiki/Motivation-and-Background)
- [Goals](https://github.com/Installomator/Installomator/wiki/Goals)
- [What it does](https://github.com/Installomator/Installomator/wiki/What-it-does)
- [Using Installomator](https://github.com/Installomator/Installomator/wiki/Using-Installomator)
- [Configuration and Variables](https://github.com/Installomator/Installomator/wiki/Configuration-and-Variables)
- [Labels Variable Reference](https://github.com/Installomator/Installomator/wiki/Label-Variables-Reference)
- [Methods to Run Installomator](https://github.com/Installomator/Installomator/wiki/Methods-to-Run-Installomator)
- [Frequently Asked Questions](https://github.com/Installomator/Installomator/wiki/Frequently-Asked-Questions)

## Authors and Contributors

Installomator was originally inspired by the download scripts from [William Smith - @talkingmoose](https://github.com/talkingmoose) and [Sander Schram - @macbofh](https://github.com/macbofh), and created by:

- [Armin Briegel - @scriptingosx](https://github.com/scriptingosx)

with help from [Erik Stam - @erikstam](https://github.com/erikstam)  

The Installomator team:
- [Armin Briegel - @scriptingosx](https://github.com/scriptingosx)
- [Isaac Ordonez - @isaacatmann](https://github.com/isaacatmann)
- [Søren Theilgaard - @Theile](https://github.com/Theile)
- [Adam Codega - @acodega](https://github.com/acodega)
- [Trevor Sysock - @BigMacAdmin](https://github.com/bigmacadmin)
- [Bart Reardon - @bartreardon](https://github.com/bartreardon)

 And with numerous contributions from many others. Thank you all, very much!
