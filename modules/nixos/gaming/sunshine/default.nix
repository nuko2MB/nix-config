{ lib, pkgs, ... }@args:
lib.nuko.mkModule args
  [
    "gaming"
    "sunshine"
  ]
  {
    #  environment.systemPackages = [ pkgs.nuko.moondeck-buddy ];
    services.sunshine = {
      enable = true;
      # use wlr backend not KMS
      capSysAdmin = false;
      openFirewall = true;
      /*
        settings = {
          # This should be the headless monitor
          output_name = 2;
          encoder = "vaapi";
          adapter_name = "/dev/dri/renderD128";
        };
      */
    };

    nuko.home.extraOptions = {
      wayland.windowManager.hyprland.settings = {
        exec-once = [
          "hyprctl output create headless"
          "hyprctl monitors | awk '/^Monitor HEADLESS/{print $2;}' | xargs -I{} hyprctl keyword monitor {}, 1200x800@90,4480x4480,auto"
        ];
      };
    };
  }
