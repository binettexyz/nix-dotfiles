{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.programs.mpv;
in
{
  options.modules.programs.mpv = {
    enable = mkOption {
      description = "Enable mpv package";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    programs.mpv = {
      enable = true;

      bindings = {
        "q" = "quit";
        "l" = "seek 5";
        "h" = "seek -5";
        "p" = "cycle pause";
        "j" = "seek -60";
        "k" = "seek +60";

        "u" = "add sub-delay -0.1";
        "Shift+u" = "add sub-delay +0.1";

        "-" = "add volume -5";
        "=" = "add volume 5";

        "s" = "cycle sub";
        "Shift+s" = "cycle sub down";

        "f" = "cycle fullscreen";

        "r" = "async screenshot";
        "Shift+r" = "async screenshot video";
      };

      config = {
          # Audio
        volume = 60;
        volume-max = 100;

        # Video
        # Remove the two lines bellow if playback issues
        #profile = "gpu-hq";
        #vo = "gpu";
        gpu-api = "vulkan";

        #hwdec = "auto";
        hwdec = "false";
  #      hwdec = "nvdec-copy";
        #icc-profile-auto = "";
        dither-depth = false; # to test

          # Languages
        alang = "ja,jp,jpn,en,eng";
        slang = "en,eng";

          # osc
        osd-font = "sans-serif"; # Sets a custom font

          # osc
        no-osc = "";
        no-osd-bar = "";
        osd-font-size = 16;
        osd-border-size = 2;

        /* Window */
        #no-border = "";
        border = false;  # to test
        #keep-open = "";
        keep-open = true;  # to test
        force-window = "immediate";
        force-seekable = true;  # to test
        cursor-autohide = 100;  # to test
        autofit = "50%x50%";
        geometry = "90%:5%";

        /* Subtitle */ # to test
        demuxer-mkv-subtitle-preroll = true;
        sub-font-size = 52;
        sub-blur = 0.2;
        sub-color = "1.0/1.0/1.0/1.0";
        sub-margin-x = 100;
        sub-margin-y = 50;
        sub-shadow-color = "0.0/0.0/0.0/0.25";
        sub-shadow-offset = 0;

        /* Scaling */ # to test
        correct-downscaling = true;
        linear-downscaling = true;
        linear-upscaling = true;
        sigmoid-upscaling = true;
        scale-antiring = 0.7;
        dscale-antiring = 0.7;
        cscale-antiring = 0.7;

          # Motion Interpolation
        #video-sync = "display-resample";
        interpolation = true;
        tscale = "oversample"; # smoothmotion

          # screenshot
        screenshot-directory = "~/pictures/screenshots";
        screenshot-template = "%F-%P";
        #screenshot-jpeg-quality = 95;
        screenshot-format = "png"; # to test
        screenshot-sw = true; # to test

        save-position-on-quit = "yes"; # Saves the seekbar position on exit
      };

      profiles = {
      };
      scripts = with pkgs.mpvScripts; [ sponsorblock ];
    };
  };

}
