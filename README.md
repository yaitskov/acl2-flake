* Cached ACL2 with all books certified

Project is ACL2 flake backed by cachix that contains all books
certified. This is a shortcut for ACL2 installation on NixOS, a common
Linux distro or Mac. The derivation is not cached by nixos.org and its
compilation with certification of all ACL2 books would take many
hours.

[cachix tutorial](https://docs.cachix.org/getting-started)

** NixOS with Flakes

*** /etc/nixos/configuration.nix

``` nix
  nix.settings = {
    substituters = [
      "https://acl2-full.cachix.org"
    ];
    trusted-public-keys = [
      "acl2-full.cachix.org-1:8/XEXFJqPPjWhSB+yI5qUh6LM0ZUi5NDK1JT88leuqg="
    ];
  };

```

*** /etc/nixos/flake.nix
``` nix
  inputs = {
    myacl2.url = "github:yaitskov/acl2-flake";
  };
  outputs = { self, nixpkgs, myacl2, ... }@inputs:
   let
      system = "x86_64-linux";
      over-free = final: prev: {
        pkgs = import nixpkgs {
          system = mysystem;
          config.allowUnfree = true;
        };
      };
  in
  {
    nixosConfigurations.myhostname = nixpkgs.lib.nixosSystem {
      modules = [
        ({ ... }: { nixpkgs.overlays = [over-free]; })
        myacl2.nixosModules.${mysystem}.default
        ({ ... }: { programs.acl2.enable = true; })
      ];
    };
  };
```

** Regular Linux

``` shell
  nix profile install --accept-flake-config nixpkgs#cachix
  cachix use acl2-full

  git clone https://github.com/yaitskov/acl2-flake
  cd acl2-flake
  nix build # build should just copy
  ./result/bin/acl2
```

** Mac

I don't have access to Mac environment and I wasn't able to populate
cache for this architecture.
