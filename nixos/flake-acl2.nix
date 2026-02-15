acl2:
{ config
, lib
, pkgs
, ...
}: let
  cfg = config.programs.acl2;
  inherit (lib) mkOption types;
in {
  options.programs.acl2 = {
    enable = lib.mkEnableOption "literal-flake-input";
    book-set = mkOption {
      type = types.enum [ "full" "basic" ];
      default = "full";
      description = "what books to certify";
    };
    certify-books = mkOption {
      type = types.bool;
      default = false;
      description = "whether to certify books";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ acl2 ];
  };
}
