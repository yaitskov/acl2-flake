{
  description = "full precertified ACL2 from with cachix";
  inputs =
    {
      acl2-src = {
        url = "http://mygit/latest.tar.gz";  # "github:acl2/acl2";
        flake = false;
      };
    };
  outputs = { nixpkgs, self, acl2-src }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      packages.x86_64-linux.default =
        pkgs.callPackage ./nixpkgs
          { certifyBooks = false;
            inherit acl2-src;
            book-set = "basic";
          };
      nixosModules.x86_64-linux.default = import ./nixos/flake-acl2.nix (self.packages.x86_64-linux.default);
    };
}
