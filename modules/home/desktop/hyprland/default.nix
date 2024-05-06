{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}@args:
with lib.nuko;
mkModule' args
  [
    "desktop"
    "hyprland"
  ]
  [
    ./hyprbinds.nix
    ./hyprgame.nix
  ]
  {

    nuko = {
      desktop = {
        waybar = enabled;
        hyprlock = enabled;
      };
      services = {
        # swayidle = enabled;
        hypridle = enabled;
      };
      programs = {
        wlogout = enabled;
      };
    };

    programs = {
      fuzzel = {
        enable = true;
        settings.main = {
          lines = 6;
          line-height = 32;
          width = 24;
          terminal = "${pkgs.foot}/bin/foot";
        };
      };
    };

    services = {
      swww = {
        enable = true;
        systemdTarget = "hyprland-session.target";
        #  startupWallpaper = osConfig.nuko.theme.wallpaper.path;
        slideshow = true;
      };
    };

    home.packages = with pkgs; [
      gnome.adwaita-icon-theme
      polkit_gnome
      qt6.qtwayland
      qt5.qtwayland
      playerctl
      swaynotificationcenter
      swayosd

      wl-clipboard
      xclip
      #onagre # Broken pkg. https://github.com/NixOS/nixpkgs/pull/235072
    ];

    services.swayosd.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      # https://wiki.hyprland.org/Configuring
      settings = {
        monitor = [
          "DP-2,1920x1080@144,0x100,1"
          "DP-1,2560x1440@170,1920x0,1"
        ];

        exec-once = [
          "{pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "${pkgs.swaynotificationcenter}/bin/swaync"
          "xrandr --output DP-1 --primary"
          "hyprctl dispatch workspace 1"

          # Gtk application bug fix. Unsure if needed. Too lazy to test.
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

          # https://github.com/hyprwm/Hyprland/issues/2319
          ''wl-paste -t text -w sh -c 'v=$(cat); cmp -s <(xclip -selection clipboard -o)  <<< "$v" || xclip -selection clipboard <<< "$v"' ''
        ];

        windowrulev2 = [
          # Guild Wars 2 Launcher Fix
          "suppressevent fullscreen maximize, title:^(Guild Wars 2)$"

          # Use foot's own transparency
          "opaque, class:foot"

          # MPV pip
          "opaque, class:mpv"
          "noblur, class:mpv"
        ];

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = -0.25;
          accel_profile = "flat";
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba (0ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          layout = "dwindle";
          allow_tearing = true;
        };

        misc = {
          vrr = 1;
          no_direct_scanout = false;
        };

        dwindle = {
          no_gaps_when_only = 0;

          pseudotile = true;
          preserve_split = true;
        };

        # Required for tearing, and also fixes AMD driver vrr cursor bug.
        env = [ "WLR_DRM_NO_ATOMIC,1" ];

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 4;
            passes = 2;
          };

          active_opacity = 0.965;
          inactive_opacity = 0.965;

          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.10, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 5, myBezier, slide"
            "windowsOut, 1, 5, myBezier, slide"
            "border, 1, 10, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        workspace = [
          "1,monitor:DP-1"
          "2,monitor:DP-2"
          "3,monitor:DP-1"
          "4,monitor:DP-2"
          "5,monitor:DP-1"
          "6,monitor:DP-2"
          "7,monitor:DP-1"
          "8,monitor:DP-2"
          "9,monitor:DP-1"
          "10,monitor:DP-2"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        bindl = [
          ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise" # wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
          ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower" # wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          ", XF86AudioPlay, exec, playerctl play-pause"
        ];
        "$mod" = "SUPER";
      };
      # Custom bind module (hyprbinds.nix)
      binds = {
        # Super Keybinds
        none = {
          RETURN = "exec, foot";
          Q = "killactive,";
          D = "exec, fuzzel";
          F = "exec, firefox --browser";
          G = "togglefloating,";
          T = "fullscreen,";
          P = "pseudo";
          J = "togglesplit";
          R = "togglegroup";
          O = "exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          left = "movefocus, l";
          right = "movefocus, r";
          up = "movefocus, u";
          down = "movefocus, d";
          mouse_down = "workspace, e+1";
          mouse_up = "workspace, e-1";

          # Workspace
          "1" = "workspace, 1";
          "2" = "workspace, 2";
          "3" = "workspace, 3";
          "4" = "workspace, 4";
          "5" = "workspace, 5";
          "6" = "workspace, 6";
          "7" = "workspace, 7";
          "8" = "workspace, 8";
          "9" = "workspace, 9";
        };
        # Super + Shift keybinds
        SHIFT = {
          BACKSPACE = "exec, ${lib.getExe config.programs.wlogout.package}";
          G = [
            "togglefloating,"
            "toggleopaque,"
            "pin,"
          ];

          # Workspace
          "1" = "movetoworkspace, 1";
          "2" = "movetoworkspace, 2";
          "3" = "movetoworkspace, 3";
          "4" = "movetoworkspace, 4";
          "5" = "movetoworkspace, 5";
          "6" = "movetoworkspace, 6";
          "7" = "movetoworkspace, 7";
          "8" = "movetoworkspace, 8";
          "9" = "movetoworkspace, 9";
        };
      };
      # Auto apply rules in `hyprland.gameRules` to the following (hyprgame.nix)
      games = [
        "class:^(steam_app_)(.*)$"
        "class:Minecraft"
        "title:FINAL FANTASY XIV"
      ];
    };
  }
