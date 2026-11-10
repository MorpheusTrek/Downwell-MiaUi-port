# Downwell - MiaUI (RG35XX) Port

Downwell on the Anbernic RG35XX running MiaUI, using the open-source Butterscotch (GameMaker runner reimplementation) engine.

Needs the original (Non-H700) RG35XX with MiaUI, the release zip, and your own Downwell `data.win` from your own copy of the game.

## Overview

Downwell for the Anbernic RG35XX running MiaUI, using the open-source Butterscotch (GameMaker runner reimplementation) engine, configured to run **Downwell** correctly on 4:3 screen.

Downwell's GUI is only `160x284`, but the game draws its 4:3 HUD *outside* that rectangle (left HUD at negative X, right HUD past X=160). The stock runner letterboxes the GUI to the `160:284` aspect ratio, which produces a narrow vertical strip in the middle of a 640x480 screen and scissors the HUD away.

This build adds a command-line option that fixes that:

```
--gui-ratio <W:H>
```

When set, the GUI is drawn across the **full screen** at the requested aspect ratio instead of being letterboxed to the game's narrow GUI size. The `160x284` play area stays centered and the same size, while the left/right HUD is no longer clipped. On a 640x480 panel, `--gui-ratio=4:3` gives the intended layout.

The option is opt-in, so other games are unaffected.

This build also adds a **Start + Select** hotkey: press both buttons together to quit back to MiaUI.

## Install

1. Download Downwell release zip.
2. Extract the zip into `PORTS/`.
3. Copy your game files (`data.win` + ogg sound files) into `/PORTS/Downwell.pak/`.
4. In MiaUI run PORTS\Downwell.

## SD folder structure

```
Ports/
  Downwell.pak/          # MiaUI pak folder name
    launch.sh
    butterscotch
    data.win              # Your own Downwell game data
	*.ogg
```

## Build from source


Prerequisites (Windows):

- Hardware Virtualization enabled in BIOS
- WSL 2 (Windows Subsystem for Linux 2)
- Docker Desktop (configured to use the WSL 2 engine)

Steps:

1. Open a terminal in this folder.
2. Run:

   ```sh
   docker build --output type=local,dest=./out .
   ```

3. Wait for it to finish. The fresh binary lands in `out/butterscotch`.

## Credits

- **Butterscotch** — the GameMaker: Studio runner re-implementation, by the [ButterscotchRunner](https://github.com/ButterscotchRunner/Butterscotch) project. Licensed under the GNU AGPL v3.
- **DSkywalk** - [MiaUI](https://github.com/miaui-cfw/MiaUI-GPU-RG35XX)
- **0xCtCpn** - inspired by [Undertale](https://github.com/0xCtCpn/Undertale-MiaUI-Port) port
- **Downwell** — created by **Ojiro Fumoto (Moppin)**, published by Devolver Digital. All game assets and code remain the property of their respective owners. This project does not include any game data; you must supply your own.