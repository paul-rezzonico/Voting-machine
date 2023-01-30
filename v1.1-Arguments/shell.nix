{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, containers, hpack, lib
      , optparse-applicative, unordered-containers
      }:
      mkDerivation {
        pname = "voting-machine";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [ base ];
        libraryToolDepends = [ hpack ];
        executableHaskellDepends = [
          base containers optparse-applicative unordered-containers
        ];
        testHaskellDepends = [ base ];
        prePatch = "hpack";
        homepage = "https://github.com/githubuser/voting-machine#readme";
        license = lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
