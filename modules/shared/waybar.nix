{ lib, pkgs, config, ... }:
let cfg = config.shared.waybar;
in {
  options.shared.waybar = {
    enable = lib.mkEnableOption "Waybar setup and config install";
    configPath = lib.mkOption { type = lib.types.nullOr lib.types.path; default = null; };
    stylePath = lib.mkOption { type = lib.types.nullOr lib.types.path; default = null; };
    scriptsDir = lib.mkOption { type = lib.types.nullOr lib.types.path; default = null; };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.waybar ];
    system.activationScripts.waybar = lib.mkAfter ''
      mkdir -p /home/scott/.config/waybar/scripts
      # Remove existing files/symlinks before creating new ones
      rm -f /home/scott/.config/waybar/config
      rm -f /home/scott/.config/waybar/style.css
      ${lib.optionalString (cfg.configPath != null) ''ln -sf ${cfg.configPath} /home/scott/.config/waybar/config''}
      ${lib.optionalString (cfg.stylePath != null) ''ln -sf ${cfg.stylePath} /home/scott/.config/waybar/style.css''}
      ${lib.optionalString (cfg.scriptsDir != null) ''cp -f ${cfg.scriptsDir}/* /home/scott/.config/waybar/scripts/ 2>/dev/null || true''}
      chown -R scott:users /home/scott/.config/waybar
    '';
  };
}


