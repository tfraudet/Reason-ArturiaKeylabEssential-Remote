# Reason-ArturiaKeylabEssential-Remote

Remote is the Propellerheadʼs protocol for communication between hardware control surfaces and Reason Studio application. This project provides Reason remote scripts for the **DAW Command Center** surface of the Arturia Keylab Essential keyboard and the **keyboard** itself (pads, encoders and faders sections).

Have a look to the [documentation](https://tfraudet.github.io/Reason-ArturiaKeylabEssential-Remote/) for scripts installation & understand the keyboard mapping with the differents devices (instruments, players, effects, utilities)

![Arturia Keylab Essential Logo](https://medias.arturia.net/images/products/keylab-essential/keylab-essential-image.png)

## Installation

* [Install Reason remote scripts for Arturia Keylab Essential](./docs/index.md)

## Mapping between Arturia control surfaces and Reason

* [DAW commands & Master Section mapping](./docs/daw-mapping.md)
* [Instruments mapping](./docs/instruments-mapping.md)
* [Effects mapping](./docs/effects-mapping.md)
* [Utilities mapping](./docs/utilities-mapping.md)
* [Players mapping](./docs/players-mapping.md)

## Ressources on Remote

* [Propellerhead Control Remote Tutorial](https://www.reasonstudios.com/blog/control-remote)
* [Reason Remoter](http://www.reasonremoter.uk/)
* [Hacking Remote Files in Reason](https://www.soundonsound.com/techniques/hacking-remote-files-reason)
* [Collection of Remote Templates for Propellerhead's Reason Rack Extensions](https://github.com/LividInstruments/Reason_RE_Remote_Templates)

## Other links

* [Markdown guide](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf)
* [Create TOC for GitHub markdown files](https://imthenachoman.github.io/nGitHubTOC/)
* [LUA 5.0 documentation](http://www.lua.org/manual/5.0/.)
* [LUA Script tutorial](https://wxlua.developpez.com/tutoriels/lua/general/cours-complet/)
* [Midi reference tables](https://www.midi.org/specifications-old/category/reference-tables)
* [Arturia Keylab Essential](https://www.arturia.com/support/keylab-essential-start)

## History

* [Changelog](./CHANGELOG.md)

## Know bugs

* When Preset is selected, jog-wheel didn't change the preset selection (on ID8, Combinator)
  * Workaround on Combinator has been to use `Select Patch Delta` remotable item and jog-wheel as delta control for now.
* Part1/Part2/Live buttons didn't select group variations on map file
  * workaround has been to use Keyboard Shortcut Variations for now.
