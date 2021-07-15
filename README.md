# .config


## nixos

rebuild with flakes
     
     nixos-rebuild switch --flake '/etc/nixos#root' --impure


format

     nixpkgs-fmt configuration.nix
