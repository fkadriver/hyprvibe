{ lib, pkgs, config, ... }:
let cfg = config.shared.hyprland;
in {
  options.shared.hyprland = {
    enable = lib.mkEnableOption "Hyprland base setup";
    waybar.enable = lib.mkEnableOption "Waybar autostart integration";
    monitorsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Per-host Hyprland monitors config file path";
    };
    wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Wallpaper file path for hyprpaper/hyprlock generation";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Install base config; host supplies monitor file separately
    system.activationScripts.hyprlandBase = lib.mkAfter ''
      mkdir -p /home/scott/.config/hypr
      # Remove existing symlinks/files if they exist
      rm -f /home/scott/.config/hypr/hyprland-base.conf
      ln -sf ${../../configs/hyprland-base.conf} /home/scott/.config/hypr/hyprland-base.conf
      ${lib.optionalString (cfg.monitorsFile != null) ''
        rm -f /home/scott/.config/hypr/$(basename ${cfg.monitorsFile})
        ln -sf ${cfg.monitorsFile} /home/scott/.config/hypr/$(basename ${cfg.monitorsFile})
      ''}
      chown -R scott:users /home/scott/.config/hypr
    '';
  };
}


