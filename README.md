# Reason-ArturiaKeylabEssential-Remote

Remote is the Propellerheadʼs protocol for communication between hardware control surfaces and Reason Studio application. This project provides Reason remote scripts for the **DAW Command Center** surface of the Arturia Keylab Essential keyboard

**Note**: I am not affiliated or associated in any way with Arturia or Propellerhead. I have created these files myself with the files and programs legally available to me.

:warning: **WARNING**: You download and use these files entirely at your own risk!

![Arturia Keylab Essential Logo](https://medias.arturia.net/images/products/keylab-essential/keylab-essential-image.png)

## Installation

### Install the scripts

To install the Remote scripts in your environement, the files in the `Remote` directory should be copied to your Propellerhead installation directory:

* On MacOS

```bash
Macintosh HD/Library/Application Support/Propellerhead Software/Remote
```

* On Window 7 and above

```bash
C:/ProgramData/Propellerhead Software/Remote
```

### Setup the Arturia DAW Command Center as the control surface in Reason

* Open the Preferences dialog and click the Control Surfaces tab.

<img src="./images/OpenControlSurfaceTab.png" width="400">

* To add manually the control surface, click the “Add manually” button. This brings up a new dialog.
* Select "Arturia Keylab 61 Essential Control" from the Model pop-up menu. Select `Arturia KeyLab 61 Essential DAW In` for `In Port` attribut and `Arturia Keylab Essential DAW Out` for `Out Port` attribut.

<img src="./images/ControlSurfaceSelection.png" width="400">

### Mapping between the Aturia DAW Command Center and Reason

<img src="./images/DAWCommandCenter.png" width="300">

Mapping of the different buttons

| Arturia DAW Command Center | Reason Command | Comment |
| -------------------------- | -------------- | ----------------------- |
| Stop | Stop | Stops playback. Pressing two time will return the playback cursor to the start of the track. |
| Pause/play | Play | Starts and pauses your track at the current position of the playback cursor. In pause mode, the stop button LED is on and the pause/play button LED is slightly on |
| Record | Record On/off | Arms the record function in Reason. Hitting the Record button while the track is stopped will begin playback while recording. If the track is already playing, hitting Record will begin recording from the current playback cursor position. |
| Loop | Loop On/off | Toggles the Loop function on and off. The loop region is set within Reason. |
| Rewind | Rewind | Quickly moves the playback cursor backward. |
| Fast forward | Fast Forward | Quickly moves the playback cursor forward. |
| Save | Redo |  Redo your last undo action. If there is no action to redo, the button's led is off |
| Undo | Undo  | Reverses your last action. If there is no action, the button's led is off |
| Punch | Precount On/Off | Toggles Reason’s metronome precount on and off. |
| Metro | Click On/Off | Toggles Reason’s metronome on and off. |

## Ressources on Remote

* [Korg Nano Kontrol](https://github.com/carlosedp/Reason-KorgNanoKontrol2-Remote) by <carlosedp@gmail.com>
* [Propellerhead Control Remote Tutorial](https://www.reasonstudios.com/blog/control-remote)
* [Reason Remoter](http://www.reasonremoter.uk/)
* [Hacking Remote Files in Reason](https://www.soundonsound.com/techniques/hacking-remote-files-reason)

## Other links

* [Markdown guide](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf)
* [LUA 5.0 documentation](http://www.lua.org/manual/5.0/.)
* [LUA Script tutorial](https://wxlua.developpez.com/tutoriels/lua/general/cours-complet/)
* [Midi reference tables](https://www.midi.org/specifications-old/category/reference-tables)
* [Arturia Keylab Essential](https://www.arturia.com/support/keylab-essential-start)
