{
  inputs = {
    home-manager.url = "github:rycee/home-manager";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nix-doom-emacs
    , emacs-overlay
    , ...
    }: {


      # emacs-overlay = (import (builtins.fetchTarball {
      #   url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      # }) self );
      nixosConfigurations.root = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.root = { pkgs, ... }: {
              imports = [ nix-doom-emacs.hmModule ];
              nixpkgs.overlays = [
                (import (builtins.fetchTarball {
                  url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
                }))
              ];
              services.emacs.package = pkgs.emacsUnstable;
              programs.doom-emacs = {
                enable = true;
                doomPrivateDir = /root/doom.d;
                # https://github.com/vlaci/nix-doom-emacs/issues/250
                #  emacsPackage = pkgs.emacsGit.override {
                #  nativeComp = true;
                #   withXwidgets = true;
                #        };
                #emacsPackage = pkgs.emacs.override {
                #version = 27;
                #versionModifier = ".1";
                #  withXwidgets = true;
                #};

                #emacsPackage = (pkgs.emacsWithPackagesFromUsePackage {
                #  # Package is optional, defaults to pkgs.emacs
                #  config = ./emacs.el;
                #  package = (pkgs.emacsGit.override {
                #    withXwidgets = true;
                #  });
                #});
                # dependencyOverrides = {
                #"emacs-overlay" = fetchFromGitHub { owner = /* ...*\/; };
                #"emacs-overlay" = fetchTarball {
                #  url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
                #  };
                #};
              };
            };
          }
        ];
      };
    };
}
