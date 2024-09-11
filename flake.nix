{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };

  outputs =
    {
      self,
      nixpkgs,
      devenv,
      systems,
      ...
    }@inputs:
    let
      forEachSystem =
        function:
        nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system: function nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forEachSystem (pkgs: {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            {
              # https://devenv.sh/reference/options/
              dotenv.disableHint = true;

              packages = with pkgs; [
                cargo-edit
                rofi-wayland
                grim
                libnotify
                slurp
                wl-clipboard
                hyprland
                sway
                tesseract
              ];

              languages.rust.enable = true;
            }
          ];
        };
      });

      packages = forEachSystem (pkgs: rec {
        focal = pkgs.callPackage ./package.nix {
          version =
            if self ? "shortRev" then
              self.shortRev
            else
              nixpkgs.lib.replaceStrings [ "-dirty" ] [ "" ] self.dirtyShortRev;
        };
        default = focal;
        no-ocr = focal.override { ocr = false; };
        focal-hyprland = focal.override { backend = "hyprland"; };
        focal-sway = focal.override { backend = "sway"; };
      });
    };
}
