{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.programs.mpv;
  anime4k = pkgs.anime4k;
  anime4kInputs = {
    "CTRL+1" = ''no-osd change-list glsl-shaders set "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_M.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode A (Fast)"'';
    "CTRL+2" = ''no-osd change-list glsl-shaders set "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_Soft_M.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode B (Fast)"'';
    "CTRL+3" = ''no-osd change-list glsl-shaders set "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Upscale_Denoise_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode C (Fast)"'';
    "CTRL+4" = ''no-osd change-list glsl-shaders set "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_M.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/Anime4K_Restore_CNN_S.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode A+A (Fast)"'';
    "CTRL+5" = ''no-osd change-list glsl-shaders set "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Restore_CNN_Soft_M.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Restore_CNN_Soft_S.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode B+B (Fast)"'';
    "CTRL+6" = ''no-osd change-list glsl-shaders set "${anime4k}/Anime4K_Clamp_Highlights.glsl:${anime4k}/Anime4K_Upscale_Denoise_CNN_x2_M.glsl:${anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/Anime4K_Restore_CNN_S.glsl:${anime4k}/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode C+A (Fast)"'';
    "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';
  };
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

          # Pro tip: Use `BACKSPACE` to stop fast-forwarding immediately.
        ")" = "script-binding fastforward/speedup"; # Make playback faster
        "(" = "script-binding fastforward/slowdown"; # Reduce speed

      } // anime4kInputs;

      scripts = with pkgs.mpvScripts; [ sponsorblock ];

      config = {

        /* --General-- */

          # Default profile
          # Can cause performance problems with some GPU drivers and GPUs.
        profile = "gpu-hq";
          # Uses GPU-accelerated video output by default
        vo = "gpu";

        /* ===== REMOVE VOLKAN SETTINGS IF YOU ENCOUNTER PLAYBACK ISSUES AFTER ===== */

          # Volkan settings
#        gpu-api = "vulkan";
#        vulkan-async-compute = "yes";
#        vulkan-async-transfer = "yes";
#        vulkan-queue-count = 1;
#        vd-lavc-dr = "yes";

          # Enable HW decoder; "false" for software decoding
          # "auto" "vaapi" "nvdec-copy" "vdpau"
        hwdec = "nvdec-copy";

        /* ---Audio--- */

          # Set default audio volume to 70%
        volume = 70;
        volume-max = 100;

        /* ---Languages--- */

        alang = "ja,jp,jpn,en,eng";
        slang = "en,eng,enUS";

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
          # displays a progress bar on the terminal
        term-osd-bar = "yes";
          # autohide the curser after 1s
        cursor-autohide = 1000;
        keep-open = "";
        force-window = "immediate";
        autofit = "50%x50%";
        geometry = "90%:5%";

        /* ---Subtitles--- */

        demuxer-mkv-subtitle-preroll = true;
        sub-font-size = 52;
        sub-blur = 0.2;
        sub-color = "1.0/1.0/1.0/1.0";
        sub-margin-x = 100;
        sub-margin-y = 50;
        sub-shadow-color = "0.0/0.0/0.0/0.25";
        sub-shadow-offset = 0;

        /* ---Scaling--- */

        gpu-shader-cache-dir = "~~/cache";

          # https://gist.github.com/igv/
          # https://gist.github.com/agyild/
          # scaler / shader
        #glsl-shader="~~/shaders/SSimSuperRes.glsl"
#        glsl-shader = [ "~~/shaders/FSR.glsl" "~~/shaders/SSimDownscaler.glsl" ];

#        scale = "ewa_lanczossharp";
#        dscale = "lanczos";
#        linear-downscaling = "no";

         /* --------------------- */

#        #correct-downscaling = true;
#        linear-downscaling = true;
#        linear-upscaling = true;
#        sigmoid-upscaling = true;
#        scale-antiring = 0.7;
#        dscale-antiring = 0.7;
#        cscale-antiring = 0.7;

          /* --------------------- */

          # Chroma subsampling means that chroma information is encoded at lower resolution than luma
          # In MPV, chroma is upscaled to luma resolution (video size) and then the converted RGB is upscaled to target resolution (screen size)
          # For detailed analysis of upscaler/downscaler quality, see https://artoriuz.github.io/blog/mpv_upscaling.html

        glsl-shaders-clr = "";
          # luma upscaling
          # note: any FSRCNNX above FSRCNNX_x2_8-0-4-1 is not worth the additional computional overhead
        glsl-shaders = "~/.config/mpv/shaders/FSRCNNX_x2_8-0-4-1.glsl";
        scale = "ewa_lanczos";
          # luma downscaling
          # note: ssimdownscaler is tuned for mitchell and downscaling=no
        glsl-shaders-append = [ "~/.config/mpv/shaders/SSimDownscaler.glsl" "~/.config/mpv/shaders/KrigBilateral.glsl" ];
        dscale = "mitchell";
        linear-downscaling = "no";
          # chroma upscaling and downscaling
        cscale = "mitchell"; # ignored with gpu-next
        sigmoid-upscaling = "yes";

        /* ---Motion Interpolation--- */
        video-sync = "display-resample";
        interpolation = true;
        tscale = "oversample"; # smoothmotion

        /* ---Misc--- */
        hr-seek-framedrop = "no";
        force-seekable = "";
        #no-input-default-bindings = "";
        no-taskbar-progress = "";
        reset-on-next-file = "pause";
        #quiet = "";
      };

      profiles = {

         "4k60" = {
            profile-desc = "4k60";
            profile-cond = "((width ==3840 and height ==2160) and p['estimated-vf-fps']>=31)";
#            deband = "yes"; # necessary to avoid blue screen with KrigBilateral.glsl
            deband = "no"; # turn off debanding because presume wide color gamut
#            interpolation = "no"; # turn off interpolation because presume 60fps 
              # UHD videos are already 4K so no luma upscaling is needed
              # UHD videos are YUV420 so chroma upscaling is still needed
            glsl-shaders-clr = "";
            glsl-shaders = "~/.config/mpv/shaders/KrigBilateral.glsl"; # enable if your hardware can support it
            interpolation = "no"; # no motion interpolation required because 60fps is hardware ceiling
            # no deinterlacer required because progressive
          };


          "4k30" = {  # 2160p @ 24-30fps (3840x2160 UHDTV)
            profile-cond = "((width ==3840 and height ==2160) and p['estimated-vf-fps']<31)";
            #deband = "yes"; # necessary to avoid blue screen with KrigBilateral.glsl
            deband = "no"; # turn off debanding because presume wide color gamut
            #UHD videos are already 4K so no luma upscaling is needed
            #UHD videos are YUV420 so chroma upscaling is still needed
            glsl-shaders-clr = "";
            glsl-shaders = "~/.config/mpv/shaders/KrigBilateral.glsl"; # enable if your hardware can support it
              # apply motion interpolation
              # no deinterlacer required because progressive
          };

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

        "protocol.http" = {
          hls-bitrate = "max"; # use max quality for HLS streams
          cache = "yes";
          no-cache-pause = ""; # don't pause when the cache runs low
        };

        "protocol.https" = {
          profile = "protocol.http";
        };

        "protocol.ytdl" = {
          profile = "protocol.http";
        };
      };
    };

    home.file.".config/mpv/shaders".source = ./etc/shaders;
    home.file.".config/mpv/scripts".source = ./etc/scripts;
    home.file.".config/mpv/script-opts".source = ./etc/script-opts;
    home.file.".config/mpv/binary".source = ./etc/binary;

  };

}
