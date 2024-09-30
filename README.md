# DOOM Launcher

A shell script for launching GZDOOM w/ mods in Terminal.

## Install

Save this ``launcher.sh`` file and add to your ``~/.bashrc`` file as an alias:

```
alias doom="sh /path/to/doom/launcher.sh"
```

## Usage

The script assumes that it resides in a directory of WAD and MOD files.  The structure of those folders is important:

```
launcher.sh
IWADs/ <-- put your DOOM wad files in here, like DOOM.WAD, DOOM2.WAD
PWADs/ <-- put your custom campaign wad files in here, nested by associated IWAD
    DOOM/ <-- DOOM campaigns
    DOOM2/ <-- DOOM2 campaigns
MODs/ <-- put any other mod files, like BrutalDoom, in here
```

The script will prompt you as it progressively builds the final command line instruction to launch the game.

## Example

```
$ doom

██████╗░░█████╗░░█████╗░███╗░░░███╗
██╔══██╗██╔══██╗██╔══██╗████╗░████║
██║░░██║██║░░██║██║░░██║██╔████╔██║
██║░░██║██║░░██║██║░░██║██║╚██╔╝██║
██████╔╝╚█████╔╝╚█████╔╝██║░╚═╝░██║
╚═════╝░░╚════╝░░╚════╝░╚═╝░░░░░╚═╝

Do you want to play a network game? (y/n): n

BASE GAME:
-----------
1) DOOM2.WAD
2) DOOM64.WAD
3) DOOM.WAD
4) HERETIC.WAD
5) HEXEN.WAD
6) PLUTONIA.WAD
7) TNT.WAD
Select an IWAD (enter number): 3

CUSTOM CAMPAIGN:
-----------------
1) DoomTheWayIdDid.wad
2) NoEndInSight.wad
3) UltimateDoomTheWayIdDid.wad
Select a PWAD (enter number): 1

MODIFICATIONS:
---------------
1) BD64game_v2.666.pk3
2) BD64maps_v2.666.pk3
3) Brutal Doom v21.11.3.pk3
4) Dar's Covers TNT.wad
5) Dar's Covers.wad
Select MODs (enter numbers separated by spaces, order matters): 3 5

COMMAND:
---------
gzdoom -iwad "IWADs/DOOM.WAD" -file "PWADs/DOOM/DoomTheWayIdDid.wad" "MODs/Brutal Doom v21.11.3.pk3" "MODs/Dar's Covers.wad"
Do you want to run this command? (y/n): n
```

## External Links

- [GZDOOM](https://github.com/ZDoom/gzdoom/releases)