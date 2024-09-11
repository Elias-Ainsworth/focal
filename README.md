# focal

focal is a rofi menu for capturing and copying screenshots or videos on hyprland / sway.

<!-- 93859049_p0.webp -->
<img src="https://i.imgur.com/3DrXV0I.png" alt="main menu" width="49%" /> <img src="https://i.imgur.com/AipxMmf.png" alt="delay menu" width="49%" />
<img src="https://i.imgur.com/5NXnkKm.png" alt="selection" width="49%" /> <img src="https://i.imgur.com/sm7PJgw.png" alt="selection" width="49%" />
<br/>
<em>Wallpaper made by the awesome <a href="https://www.pixiv.net/en/users/2993192">Rosuuri</a></em>

## Features

- rofi menu to select area or window to capture / capture the entire screen
- rofi menu to select delay before capture
- image / video is automatically copied to clipboard, ready for pasting into other programs
- notifications when screenshots are captured
- all options are also avaiable via a CLI
- supports either hyprland or sway
- OCR support to select text from captured image (CLI only)

## Installation

```nix
{
  inputs.focal = {
    url = "github:iynaix/focal";
    inputs.nixpkgs.follows = "nixpkgs"; # override this repo's nixpkgs snapshot
  };
}
```

Then, include it in your `environment.systemPackages` or `home.packages` by referencing the input:
```nix
inputs.focal.packages.${pkgs.system}.default
```
For sway support, use:
```nix
inputs.focal.packages.${pkgs.system}.focal-sway
```

Alternatively, it can also be run directly:

```sh
nix run github:iynaix/focal
```

OCR support can be optionally disabled through the use of an override:
```nix
(inputs.focal.packages.${pkgs.system}.default.override { ocr = false; })
```

## Usage

```console
$ focal --help
focal is a rofi menu for capturing and copying screenshots or videos on hyprland / sway.

Usage: focal [OPTIONS] [FILE]

Arguments:
  [FILE]
          files are created in XDG_PICTURES_DIR/Screenshots or XDG_VIDEOS_DIR/Screencasts if not specified

Options:
      --rofi
          display rofi menu for options

      --no-icons
          do not show icons for rofi menu

      --theme <THEME>
          path to a rofi theme

      --area <AREA>
          type of area to capture

          [possible values: monitor, selection, all]

      --delay <DELAY>
          delay in seconds before capturing

      --slurp <SLURP>
          options to pass to slurp

      --no-notify
          do not show notifications

      --no-save
          do not save the file permanently

      --video
          record video instead of screenshots

      --audio
          capture video with audio

      --edit <PROGRAM>
          edit screenshot using PROGRAM

      --ocr [<LANG>]
          runs OCR on the selected text, defaulting to English, supported languages can be shown using 'tesseract --list-langs'

  -h, --help
          Print help (see a summary with '-h')

  -V, --version
          Print version
```

## Packaging

To build focal from source

- Build dependencies
    * Rust (cargo, rustc)
- Runtime dependencies
    * [grim](https://sr.ht/~emersion/grim/)
    * [libnotify](https://gitlab.gnome.org/GNOME/libnotify)
    * [slurp](https://github.com/emersion/slurp)
    * [hyprland](https://hyprland.org/)
    * [sway](https://swaywm.org/)
    * [rofi-wayland](https://github.com/lbonn/rofi)
    * [wl-clipboard](https://github.com/bugaevc/wl-clipboard)
    * [wf-recorder](https://github.com/ammen99/wf-recorder)
    * [ffmpeg](https://www.ffmpeg.org/)

## Hacking

Just use `nix develop`