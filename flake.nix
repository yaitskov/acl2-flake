{
  description = "full precertified ACL2 from with cachix";
  inputs =
    {
      acl2-src = {
        # url = "github:acl2/acl2";
        url = "http://mygit/latest.tar.gz"; # HEAD=a52827fa05
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
          { certifyBooks = true;
            inherit acl2-src;
            book-set = "full";
          };
      nixosModules.x86_64-linux.default = import ./nixos/flake-acl2.nix (self.packages.x86_64-linux.default);
    };
}
