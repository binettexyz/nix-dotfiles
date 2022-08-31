#!/bin/nix
{ pkgs, ... }: {
  
  
  home-manager.users.binette.programs.mpv = {
    enable = true;

    bindings = {
      "q" = "quit";
      "l" = "seek 5";
      "h" = "seek -5";
      "p" = "cycle pause"        ;                  # toggle pause/playback mode
      "j" = "seek -60";                        # skip to next file
      "k" = "seek +60";                        # skip to previous file

      "u" = "add sub-delay -0.1";                   # subtract 100 ms delay from subs
      "Shift+u" = "add sub-delay +0.1";             # add

      "-" = "add volume -5";
      "=" = "add volume 5";

      "s" = "cycle sub";                            # cycle through subtitles
      "Shift+s" = "cycle sub down";                 # ...backwards

      "f" = "cycle fullscreen";                     # toggle fullscreen

      "r" = "async screenshot";                     # take a screenshot
      "Shift+r" = "async screenshot video";         # screenshot without subtitles
    };

    config = {
        # Audio
      volume = 60;
      volume-max = 100;

        # Video
        # Remove the two lines bellow if playback issues
      profile = "gpu-hq";
      vo = "gpu";
#      gpu-api = "vulkan";

      hwdec = "auto";
#      hwdec = "nvdec-copy";
      icc-profile-auto = "";

        # https://gist.github.com/igv/
        # https://gist.github.com/agyild/
        # Shader / Scaler
#      gpu-shader-cache-dir = "~~/shaders/cache";
#      glsl-shader = "~~/shaders/FSR.glsl";
#      glsl-shader = "~~/shaders/SSimDownscaler.glsl";

        # Upscaling & Processing
      glsl-shaders-clr = "";
        # luma upscaling
        # note: any FSRCNNX above FSRCNNX_x2_8-0-4-1 is not worth the additional computional overhead
      glsl-shaders = "./shaders/FSRCNNX_x2_8-0-4-1.glsl";
      scale = "ewa_lanczos";
        # luma downscaling
        # note: ssimdownscaler is tuned for mitchell and downscaling=no
      glsl-shaders-append = "./shaders/SSimDownscaler.glsl";
      dscale = "mitchell";
      linear-downscaling = "no";
        # chroma upscaling and downscaling
#      glsl-shaders-append = "./shaders/KrigBilateral.glsl";
#      cscale = "mitchell";
#      sigmoid-upscaling = "yes";

#      scale = "ewa_lanczossharp";
#      dscale = "lanczos";
#      linear-downscaling = "no";

        # Languages
      alang = "ja,jp,jpn,en,eng";
      slang = "en,eng";

        # osc
      osd-font = "Fira Code"; # Sets a custom font

        # osc
      no-osc = "";
      no-osd-bar = "";
      osd-font-size = 16;
      osd-border-size = 2;

        # window
      no-border = "";
      keep-open = "";
      force-window = "immediate";
      autofit = "50%x50%";
      geometry = "90%:5%";


        # Motion Interpolation
      override-display-fps = 60;
      video-sync = "display-resample";
      interpolation = "yes";
      tscale = "oversample"; # smoothmotion

        # screenshot
      screenshot-directory = "~/pictures/screenshots";
      screenshot-template = "%F-%P";
      screenshot-jpeg-quality = 95;

      save-position-on-quit = "yes"; # Saves the seekbar position on exit

    };

    profiles = {

    };

    scripts = with pkgs; [
      mpvScripts.sponsorblock
    ];

  };

}
