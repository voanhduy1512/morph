{ nixpkgs ? import ./nixpkgs.nix
, pkgs ? import nixpkgs {}
, version ? "dev"
}:

pkgs.buildGoModule rec {
  name = "morph-unstable-${version}";
  inherit version;

  src = pkgs.nix-gitignore.gitignoreSource [] ./.;

  ldflags = [
    "-X main.version=${version}"
  ];
  preBuild = ''
    ldflags+=" -X main.assetRoot=$lib"
  '';

  vendorSha256 = "1vf0p9xgjgpkrky41mv4ybp0hc3lls1hgh719d2al01gj8ccxhrn";

  postInstall = ''
    mkdir -p $lib
    cp -v ./data/*.nix $lib
  '';

  outputs = [ "out" "lib" ];

  meta = {
    homepage = "https://github.com/DBCDK/morph";
    description = "Morph is a NixOS host manager written in Golang.";
  };
}
