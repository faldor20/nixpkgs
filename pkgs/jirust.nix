
{ lib, pkgs, rustPlatform, ... }:

rustPlatform.buildRustPackage rec {
  pname = "jirust";
  version = "1.2.1";

  src = fetchTarball {
    url = "https://github.com/Code-Militia/jirust/archive/refs/tags/1.2.1.tar.gz";
    sha256 = "0mpxs0bj225ls0bakk5d9hp0vxwpsbhfz2vwwdb6y1rdgy7klzgf";
  };

  cargoSha256 = "";
}
