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




        "v" = "cycle deband";
        "a" = "cycle audio";
        "i" = "script-binding stats/display-stats-toggle";
        "b" = "apply-profile basic; show-text 'Shaders cleared'"; 
        "U" = "show-text 'Anime4k mode';script-message cycle-commands 'apply-profile ani4k' 'apply-profile ssim'";
        "Y" = "show-text 'Sharp mode';script-message cycle-commands 'apply-profile sharp1' 'apply-profile sharp0'";
        "F4" = "cycle-values video-aspect-override '16:9' '4:3' '2.35:1' '-1'";

          #imageviewer#

        "1 {image-viewer}" = "change-list script-opts append image_positioning-drag_to_pan_margin=200";
        "2 {image-viewer}" = "change-list script-opts append ruler-exit_bindings=8";
        "3 {image-viewer}" = "change-list script-opts append ruler-line_color=FF";
        "4 {image-viewer}" = "change-list script-opts append ruler-scale=25";
        "5 {image-viewer}" = "change-list script-opts append ruler-max_size=20,20";

        "SPACE {image-viewer}" = "repeatable playlist-next";
        "alt+SPACE {image-viewer}" = "repeatable playlist-prev";

        "H {image-viewer}" = "repeatable playlist-prev";
        "L {image-viewer}" = "repeatable playlist-next";

          # mouse-centric bindings
        "MBTN_RIGHT {image-viewer}" = "script-binding drag-to-pan";
        "MBTN_LEFT {image-viewer}" = "script-binding pan-follows-cursor";
        "MBTN_LEFT_DBL {image-viewer}" = "ignore";
        "WHEEL_UP {image-viewer}" = "script-message cursor-centric-zoom 0.1";
        "WHEEL_DOWN {image-viewer}" = "script-message cursor-centric-zoom -0.1";


          # panning with the keyboard:
          # pan-image takes the following arguments
          # pan-image AXIS AMOUNT ZOOM_INVARIANT IMAGE_CONSTRAINED
          #            ^            ^                  ^
          #          x or y         |                  |
          #                         |                  |
          #   if yes, will pan by the same         if yes, stops panning if the image
          #     amount regardless of zoom             would go outside of the window

        "ctrl+down {image-viewer}" = "repeatable script-message pan-image y -0.1 yes yes";
        "ctrl+up {image-viewer}" = "repeatable script-message pan-image y +0.1 yes yes";
        "ctrl+right {image-viewer}" = "repeatable script-message pan-image x -0.1 yes yes";
        "ctrl+left {image-viewer}" = "repeatable script-message pan-image x +0.1 yes yes";

          # now with more precision
        "alt+down {image-viewer}" = "repeatable script-message pan-image y -0.01 yes yes";
        "alt+up {image-viewer}" = "repeatable script-message pan-image y +0.01 yes yes";
        "alt+right {image-viewer}" = "repeatable script-message pan-image x -0.01 yes yes";
        "alt+left {image-viewer}" = "repeatable script-message pan-image x +0.01 yes yes";

          # reset the image
        "ctrl+0 {image-viewer}" = "no-osd set video-pan-x 0; no-osd set video-pan-y 0; no-osd set video-zoom 0";

        "+ {image-viewer}" = "add video-zoom 0.5";
        "- {image-viewer}" = "add video-zoom -0.5; script-message reset-pan-if-visible";
        "= {image-viewer}" = "no-osd set video-zoom 0; script-message reset-pan-if-visible";
        
        "e {image-viewer}" = "script-message equalizer-toggle";
        "alt+e {image-viewer}" = "script-message equalizer-reset";
        
        "h {image-viewer}" = "no-osd vf toggle hflip; show-text 'Horizontal flip'";
        "v {image-viewer}" = "no-osd vf toggle vflip; show-text 'Vertical flip'";
        
        "r {image-viewer}" = "script-message rotate-video 90; show-text 'Clockwise rotation'";
        "R {image-viewer}" = "script-message rotate-video -90; show-text 'Counter-clockwise rotation'";
        "alt+r {image-viewer}" = "no-osd set video-rotate 0; show-text 'Reset rotation'";
        
        "d {image-viewer}" = "script-message ruler";
        
          # Toggling between pixel-exact reproduction and interpolation
        "a {image-viewer}" = "cycle-values scale nearest ewa_lanczossharp";
        
          # Screenshot of the window output
        "S {image-viewer}" = "screenshot window";
        "s {image-viewer}" = "script-message status-line-toggle ";
        
          # ADVANCED: you can define bindings that belong to a "section" (named "image-viewer" here) like so:
          #alt+SPACE {image-viewer} repeatable playlist-prev
          #SPACE     {image-viewer} repeatable playlist-next
          # to load them conditionally with a command. See scripts-opts/image_viewer.conf for how you can do this

      } // anime4kInputs;

      scripts = with pkgs.mpvScripts; [ sponsorblock ];

      config = {

        /* ---Renderer--- */

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

        /* --General-- */

        hr-seek-framedrop = "no";
        force-seekable = "";
        #no-input-default-bindings = "";
        no-taskbar-progress = "";
        reset-on-next-file = "pause";
        quiet = "";

        /* ---Audio--- */

        volume = 80;
        volume-max = "150"; # maximum volume in %, everything above 100 results in amplification
        audio-stream-silence = ""; # fix audio popping on random seek
        audio-file-auto = "fuzzy"; # external audio doesn't has to match the file name exactly to autoload
        audio-pitch-correction = "yes"; # automatically insert scaletempo when playing with higher speed

        /* ---Languages--- */

        alang = "ja,jp,jpn,en,eng,enUS,en-us";
        slang = "en,eng,enUS";

        /* ---Screenshot--- */

        screenshot-directory = "~/pictures/screenshots";
        #screenshot-template = "%F-%P";
        screenshot-template = "~/pictures/screenshots/-%F-T%wH.%wM.%wS.%wT-F%{estimated-frame-number}";
        screenshot-format = "png";
        screenshot-png-compression = 4;		# Range is 0 to 10. 0 being no compression. compute-time to size is log so 4 is best
        screenshot-tag-colorspace = "yes";
        screenshot-high-bit-depth = "yes";		# Same output bitdepth as the video
#        screenshot-sw = true; # to test

        /* ---UI--- */

          # osc
        osc = "no"; # Disable default UI
        osd-bar = "no"; # Disable default seeking/volume indicators
        border = "no"; # Hide the window title bar
        osd-font = "sans-serif"; # Set a font for OSC
        osd-font-size = 20;
#        osd-border-size = 2;

          # Color log messages on terminal
        msg-color = "yes";
        msg-module = "yes";
          # displays a progress bar on the terminal
        term-osd-bar = "yes";
          # autohide the curser after 1s
        cursor-autohide = 1000;
#        keep-open = "";
        force-window = "immediate";
        autofit = "50%x50%";
        geometry = "90%:5%";

        /* ---Subtitles--- */

        sub-ass-scale-with-window = "no";		# May have undesired effects with signs being misplaced.
        sub-auto = "fuzzy";                          # external subs don't have to match the file name exactly to autoload
        #sub-gauss = "0.6";				# Some settings fixing VOB/PGS subtitles (creating blur & changing yellow subs to gray)
        demuxer-mkv-subtitle-preroll = "yes";       	# try to correctly show embedded subs when seeking
        embeddedfonts = "yes";			# use embedded fonts for SSA/ASS subs
        sub-fix-timing = "no";                      	# do not try to fix gaps (which might make it worse in some cases). Enable if there are scenebleeds.
        sub-file-paths-append = [ # search for external subs in these relative subdirectories
          "ass"
          "srt"
          "sub"
          "subs"
          "subtitles"
        ];
        
          # Subs - Forced 
        sub-font = "Open Sans SemiBold";
        sub-font-size = "46";
        sub-blur = "0.3";
        sub-border-color = "0.0/0.0/0.0/0.8";
        sub-border-size = "3.2";
        sub-color = "0.9/0.9/0.9/1.0";
        sub-margin-x = 100;
        sub-margin-y = 50;
        sub-shadow-color = "0.0/0.0/0.0/0.25";
        sub-shadow-offset = 0;

        /* ---Motion Interpolation--- */

        video-sync = "display-resample";
        interpolation = true;
        tscale = "oversample"; # smoothmotion
        
        blend-subtitles = "no";

        /* ---Debanding--- */

        deband = "yes";
        deband-iterations = "2";
        deband-threshold = "34";
        deband-range = "16";
        deband-grain = "48";
        dither-depth = "auto";

        /* ---Video Profiles--- */

        dither = "fruit";
        scale = "ewa_lanczos";
        cscale = "lanczos";
        dscale = "mitchell";
        scale-antiring = 0;
        cscale-antiring = 0;
        correct-downscaling = "yes";
        linear-downscaling = "no";
        sigmoid-upscaling = "yes";

        /* ---Scaling--- */

      };

      profiles = {

          #Anime4k
        "ani4k" = {
          vo = "gpu";
          scale = "mitchell";
          glsl-shaders-clr = "";
          glsl-shaders = [
            "~~/shaders/Anime4K_Restore_CNN_Soft_VL.glsl"
            "~~/shaders/Anime4K_Deblur_DoG.glsl"
            "~~/shaders/Anime4K_Thin_HQ.glsl"
            "~~/shaders/Anime4K_Darken_HQ.glsl"
            "~~/shaders/Anime4K_Upscale_Denoise_CNN_x2_UL.glsl"
            "~~/shaders/Anime4K_Clamp_Highlights.glsl"
          ];
        };

            #SSIM
          "ssim" = {
            vo = "gpu-next";
            scale = "lanczos";
            glsl-shaders-clr = "";
            glsl-shaders-append = [
              "~~/shaders/adaptive-sharpen4k.glsl"
              "~~/shaders/SSimSuperRes.glsl"
              "~~/shaders/SSimDownscaler.glsl"
            ];
            deband-grain = 60;
          };

            #AUDIO PLAYER OSC#
          "audio" = {
            glsl-shaders-clr = "";
            scale = "lanczos";
            glsl-shaders-append = [
              "~~/shaders/SSimSuperRes.glsl"
              "~~/shaders/SSimDownscaler.glsl"
            ];
          };

            "extension.mkv" = {
              profile = "mkv";
            };

            "low-res video" = {
              profile-desc = "cond:(get('height', math.huge) < 720) and (get('estimated-frame-count', math.huge) > 2)";
              scale = "lanczos";
              glsl-shaders-append = "~~/shaders/adaptive-sharpen.glsl";
              deband-grain = 60;
            };

            "720p video" = {
              profile-desc = "cond:(get('height', math.huge) < 721) and (get('height', math.huge) > 719) and (get('estimated-frame-count', math.huge) > 2)";
              scale = "lanczos";
              glsl-shaders-append = "~~/shaders/SSimSuperRes.glsl";
              deband-grain = 100;
            };

            "hi-res video" = {
              profile-desc = "cond:get('height', math.huge) > 720 and (get('estimated-frame-count', math.huge) > 2) or (get('estimated-frame-count', math.huge) ~= 0)";
              scale = "lanczos";
              glsl-shaders = [
                "~~/shaders/adaptive-sharpen4k.glsl"
                "~~/shaders/SSimSuperRes.glsl"
              ];
            };

            "mkv" = {
              cache = "yes";
              demuxer-max-bytes = "2000MiB";
            };

              #image shaders#

            "hi-res-image" = {
              profile-desc = "cond:(get('current-window-scale', math.huge) <= 1) and (get('estimated-frame-count', math.huge) == 1 or get('estimated-frame-count', math.huge) == 0)";
              dscale = "lanczos";
              dscale-blur = "0.8";
              glsl-shaders-clr = "";
              glsl-shaders = [
                "~~/shaders/SSimDownscaler.glsl"
                "~~/shaders/KrigBilateral.glsl"
              ];
            };

            "low-res-image" = {
              profile-desc = "cond:(get('current-window-scale', math.huge) > 1) and (get('estimated-frame-count', math.huge) == 1 or get('estimated-frame-count', math.huge) == 0)";
              scale = "mitchell";
              fbo-format = "rgba16hf";
              glsl-shaders-clr = "";
              glsl-shaders-append = [
                "~~/shaders/FSRCNNX_x2_8-0-4-1.glsl"
                "~~/shaders/KrigBilateral.glsl"
                "~~/shaders/SSimDownscaler.glsl"
              ];
            };

            "basic" = {
              glsl-shaders-clr = "";			#binded to button b in input config to clear shaders-for testing only
              scale = "ewa_lanczossharp";
            };

              #Sharpen image

            "sharp1" = {
              glsl-shaders-clr = "";
              scale = "lanczos";
              glsl-shaders-append = [
                "~~/shaders/adaptive-sharpen8k.glsl"
                "~~/shaders/SSimSuperRes.glsl"
                "~~/shaders/SSimDownscaler.glsl"
              ];
                deband-grain = 60;
            };
            
            "sharp0" = {
              glsl-shaders-clr = "";
              scale = "lanczos";
              dscale = "lanczos";
              glsl-shaders-append = [
                "~~/shaders/FSRCNNX_x2_8-0-4-1.glsl"
                "~~/shaders/KrigBilateral.glsl"
                "~~/shaders/SSimDownscaler.glsl"
              ];
            };

            "protocol.file" = {
              network-timeout = 0;
              force-window = "yes";
              cache = "yes";
              demuxer-max-bytes = "2000MiB";
              demuxer-readahead-secs = 300;
              force-seekable = "yes";
            };
            "protocol-network" = {
              network-timeout = 5;
              #force-window = "immediate";
              hls-bitrate = "max";
              cache = "yes";
              demuxer-max-bytes = "2000MiB";
              demuxer-readahead-secs = "300";
            };

            "protocol.http" = {
              profile = "protocol-network";
            };

            "protocol.https" = {
              profile = "protocol-network";
            };

            "protocol.ytdl" = {
              profile = "protocol.network";
            };

            "image" = {
              profile-cond = "image";
              "--icc-profile-auto" = "no";
              #background = "0.1"; # dark grey background instead of pure black
              mute = "yes";
              osc = "no";		# the osc is mostly useful for videos
              sub-auto = "no";				# don't try to autoload subtitles or audio files
              audio-file-auto = "no";			# get rid of the useless V: 00:00:00 / 00:00:00 line
              image-display-duration = "inf";	# don't slideshow by default
              loop-file = "inf";				# loop files in case of webms or gifs
              loop-playlist = "inf";			# and loop the whole playlist
              window-dragging = "no";			# you need this if you plan to use drag-to-pan or pan-follows-cursor with MOUSE_LEFT
              deband = "no";
            };

            "extension.png" = {
              video-aspect-override = "no";
            };
            "extension.jpg" = {
              video-aspect-override = "no";
            };
            "extension.jpeg" = {
              profile = "extension.jpg";
            };
      };
    };

    home.file.".config/mpv/shaders".source = ./etc/shaders;
    home.file.".config/mpv/scripts".source = ./etc/scripts;
    home.file.".config/mpv/script-opts".source = ./etc/script-opts;
    home.file.".config/mpv/binary".source = ./etc/binary;

  };

}
