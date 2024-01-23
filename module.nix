self: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.gist-musicbox;
in {
  options.services.gist-musicbox = let
    inherit (lib) mkEnableOption mkOption mkPackageOption types;
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    enable = mkEnableOption "Gist-Musicbox";
    package = mkPackageOption self.packages.${system} "default" {};

    envFile = mkOption {
      type = types.path;
      description = "The environment file with credentials.";
    };

    user = mkOption {
      type = types.str;
      default = "gist-musicbox";
      description = "The user to run gist-musicbox under.";
    };
    group = mkOption {
      type = types.str;
      default = "gist-musicbox";
      description = "The group to run gist-musicbox under.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.gist-musicbox = {
      description = "gist-musicbox";
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target"];

      serviceConfig = {
        Restart = "on-failure";
        ExecStart = "${lib.getExe cfg.package}";
        EnvironmentFile = cfg.envFile;
        User = cfg.user;
        Group = cfg.group;
      };
    };

    users = {
      users.gist-musicbox = lib.mkIf (cfg.user == "gist-musicbox") {
        isSystemUser = true;
        group = cfg.group;
      };
      groups.gist-musicbox = lib.mkIf (cfg.group == "gist-musicbox") {};
    };
  };
}
