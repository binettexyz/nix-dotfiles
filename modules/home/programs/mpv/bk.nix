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
        "Q" = "quit-watch-later"; # exit and remember the playback position
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

        /* ---General--- */

          # Default profile
          # Can cause performance problems with some GPU drivers and GPUs.
        profile = "gpu-hq";
          # Uses GPU-accelerated video output by default
        vo = "gpu";

        /* ===== REMOVE THE ABOVE FIVE LINES AND RESAVE IF YOU ENCOUNTER PLAYBACK ISSUES AFTER ===== */

          # Volkan settings
        gpu-api = "vulkan";
        vulkan-async-compute = "yes";
        vulkan-async-transfer = "yes";
        vulkan-queue-count = 1;
        vd-lavc-dr = "yes";

          # Enable HW decoder; "false" for software decoding
#        hwdec = "auto";
        hwdec = "vaapi";
#        hwdec = "nvdec-copy";
#        hwdec = "false";

          # Uses a large seekable RAM cache even for local input.
        cache = "yes";
#        cache-secs = 300;
          # Uses extra large RAM cache (needs cache=yes to make it useful).
        demuxer-max-bytes = "2048MiB";
        demuxer-max-back-bytes = "2048MiB";

        /* ---Audio--- */

          # Set default audio volume to 70%
        volume = 70;
        volume-max = 100;

        /* ---Languages--- */

        alang = "ja,jp,jpn,en,eng";
        slang = "en,eng";

        /* ---Screenshot--- */

        screenshot-directory = "~/pictures/screenshots";
        screenshot-template = "%F-%P";
        screenshot-format = "png"; # to test
        screenshot-sw = true; # to test

        /* ---UI--- */

          # osc
        no-osc = "";
        no-osd-bar = "";
        osd-font-size = 16;
        osd-border-size = 2;

          # Hide the window title bar
        no-border = "";
          # Color log messages on terminal
        msg-color = "yes";
          # used on 5K iMac to prevent scaling by OSX
        no-hidpi-window-scale = "";
          # displays a progress bar on the terminal
        term-osd-bar = "yes";
          # autohide the curser after 1s
        cursor-autohide = 1000;
        keep-open = "";
        force-window = "immediate";
        #force-seekable = true;  # to test
        autofit = "50%x50%";
        geometry = "90%:5%";

        /* ---Playback--- */
          /* ---TEST--- */
          # global reset of deinterlacing to off
        deinterlace = "no";

        /* ---Colorspace--- */

          # see https://github.com/mpv-player/mpv/wiki/Video-output---shader-stage-diagram
        target-prim = "auto";
        target-trc = "auto";
        gamma-auto = "";
        video-output-levels = "full";

        /* ---Dither--- */

        dither-depth = "auto";
        temporal-dither = "yes";
        dither = "fruit";

        /* ---Debanding--- */
        
        deband = "yes"; # enabled by default
        deband-iterations = 4; # deband steps
        deband-threshold = 48; # deband strength
        deband-range = 16; # deband range
        deband-grain = 48; # dynamic grain: set to "0" if using the static grain shader

        /* ---Subtitles--- */

        blend-subtitles = "yes"; # to test


        /* ---Motion Interpolation--- */

        override-display-fps = "60";
        video-sync = "display-resample";
        interpolation = "yes";
        tscale = "oversample"; # smoothmotion

        /* ---Anti-Ringing--- */
        
        scale-antiring = "0.7"; # luma upscale deringing
        dscale-antiring = "0.7"; # luma downscale deringing
        cscale-antiring = "0.7"; # chroma upscale deringing

        /* ---Upscaling--- */


      };

        /* --Profiles-- */

      profiles = {
        "default" = {
          profile-restore = "copy-equal"; # Sets the profile restore method to "copy if equal"
        };

        /* ---Other profiles--- */

        "full-hd60" = { # 1080p @ 60fps (progressive ATSC)
          profile-desc = "full-hd60";
          profile-cond = "((width ==1920 and height ==1080) and not p['video-frame-info/interlaced'] and p['estimated-vf-fps']>=31)";
            # apply all luma and chroma upscaling and downscaling settings
          interpolation = "no"; # no motion interpolation required because 60fps is hardware ceiling
            # no deinterlacer required because progressive
        };

        "full-hd30" = { # 1080p @ 24-30fps (NextGen TV/ATSC 3.0, progressive Blu-ray)
          profile-desc = "full-hd30";
          profile-cond = "((width ==1920 and height ==1080) and not p['video-frame-info/interlaced'] and p['estimated-vf-fps']<31)";
            # apply all luma and chroma upscaling and downscaling settings
            # apply motion interpolation
            # no deinterlacer required because progressive
        };

        "full-hd-interlaced" = { # 1080i @ 24-30fps (HDTV, interlaced Blu-rays)
          profile-desc = "full-hd-interlaced";
          profile-cond = "((width ==1920 and height ==1080) and p['video-frame-info/interlaced'] and p['estimated-vf-fps']<31)";
            # apply all luma and chroma upscaling and downscaling settings
            # apply motion interpolation
          vf = "bwdif"; # apply FFMPEG's bwdif deinterlacer
        };

        "hd" = { # 720p @ 60 fps (HDTV, Blu-ray - progressive)
          profile-desc = "hd";
          profile-cond = "(width ==1280 and height ==720)";
            # apply all luma and chroma upscaling and downscaling settings
          interpolation = "no"; # no motion interpolation required because 60fps is hardware ceiling
            # no deinterlacer required because progressive
        };

        "sdtv-ntsc" = { # 640x480, 704x480, 720x480 @ 30fps (NTSC DVD - interlaced)
          profile-desc = "sdtv-ntsc";
          profile-cond = "((width ==640 and height ==480) or (width ==704 and height ==480) or (width ==720 and height ==480))";
            # apply all luma and chroma upscaling and downscaling settings
            # apply motion interpolation
          vf = "bwdif"; # apply FFMPEG's bwdif deinterlacer
        };

        "sdtv-pal" = { # 352x576, 480x576, 544x576, 720x576 @ 30fps (PAL broadcast or DVD - interlaced)
          profile-desc = "sdtv-pal";
          profile-cond = "((width ==352 and height ==576) or (width ==480 and height ==576) or (width ==544 and height ==576) or (width ==720 and height ==576))";
            # apply all luma and chroma upscaling and downscaling settings
            # apply motion interpolation
          vf = "bwdif"; # apply FFMPEG's bwdif deinterlacer
        };

        /* ---File Type Profiles--- */
          # GIF Files
        "extension.gif" = {
          profile-restore = "copy-equal"; # Sets the profile restore method to "copy if equal"
          profile-desc = "gif";
          cache = "no";
          no-pause = "";
          loop-file = "yes";
        };
          # WebM Files
        "extension.webm" = {
          profile-restore = "copy-equal"; # Sets the profile restore method to "copy if equal"
          profile-desc = "webm";
          no-pause = "";
          loop-file = "yes";
        };

        /* ---Protocol Specific Configuration--- */

      };
    };

    home.file.".config/mpv/shaders".source = ./etc/shaders;

  };

}
