{
  version,
  lib,
  installShellFiles,
  rustPlatform,
  makeWrapper,
  ffmpeg,
  grim,
  procps,
  rofi-wayland,
  slurp,
  tesseract,
  wf-recorder,
  wl-clipboard,
  xdg-utils,
  hyprland,
  sway,
  backend ? "hyprland",
  ocr ? true,
}:
assert lib.assertOneOf "backend" backend [
  "hyprland"
  "sway"
];
rustPlatform.buildRustPackage {
  pname = "focal";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.difference ./. (
      # don't include in build
      lib.fileset.unions [
        ./README.md
        ./LICENSE
        # ./PKGBUILD
      ]
    );
  };

  inherit version;

  # inject version from nix into the build
  env.NIX_RELEASE_VERSION = version;

  cargoLock.lockFile = ./Cargo.lock;

  cargoBuildFlags =
    [
      "--no-default-features"
      "--features"
      backend
    ]
    ++ lib.optionals ocr [
      "--features"
      "ocr"
    ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    installShellCompletion --cmd focal \
      --bash <($out/bin/focal generate bash) \
      --fish <($out/bin/focal generate fish) \
      --zsh <($out/bin/focal generate zsh)
  '';

  postFixup =
    let
      binaries =
        [
          ffmpeg
          grim
          procps
          rofi-wayland
          slurp
          wf-recorder
          wl-clipboard
          xdg-utils
        ]
        ++ lib.optional (backend == "hyprland") hyprland
        ++ lib.optional (backend == "sway") sway
        ++ lib.optional ocr tesseract;
    in
    "wrapProgram $out/bin/focal --prefix PATH : ${lib.makeBinPath binaries}";

  meta = with lib; {
    description = "Focal captures screenshots / videos using rofi, with clipboard support on hyprland";
    mainProgram = "focal";
    homepage = "https://github.com/iynaix/focal";
    license = licenses.mit;
    maintainers = [ maintainers.iynaix ];
  };
}
