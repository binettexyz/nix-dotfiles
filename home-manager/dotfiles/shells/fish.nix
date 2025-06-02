{config, ...}: 
let
  cfg = config.colorScheme.palette; 
in {
  programs.fish = {
    enable = true;
    shellInit = ''
      # Universal environment setup
      set -e fish_user_paths
      set -U fish_user_paths $HOME/.local/bin $HOME/Applications $fish_user_paths
  
      set -U fish_key_bindings fish_vi_key_bindings
      set -gx TERM "xterm-256color"
      set -gx FZF_DEFAULT_OPTS "--layout=reverse --exact --border=bold --border=rounded --margin=3% --color=dark"
      set -gx MANPAGER "nvim +Man!"
    '';
    interactiveShellInit = ''
      # Remove greeting
      set fish_greeting

      function fish_mode_prompt
        # Do nothing — disables the [I]/[N] indicator
      end

      # Prompt
      function fish_prompt
        set_color magenta
        echo -n "["
        set_color green
        echo -n (whoami)
        set_color white
        echo -n "@"
        set_color cyan
        echo -n (hostname -s)
        set_color blue
        echo -n " "(prompt_pwd)
        set_color magenta
        echo -n "]"
        set_color white
        echo -n "\$ "
        set_color normal
      end

      set -U fish_color_command ${cfg.green}
      set -U fish_color_param ${cfg.white}
      set -U fish_color_error ${cfg.red} --bold
      set -U fish_color_operator ${cfg.cyan}
      set -U fish_color_comment ${cfg.yellow}
      set -U fish_color_quote ${cfg.magenta}
    '';
    functions = {
      # !! expansion
      __history_previous_command = ''
        switch (commandline -t)
        case "!"
          commandline -t $history[1]; commandline -f repaint
        case "*"
          commandline -i !
        end
      '';
    
      # !$ expansion
      __history_previous_command_arguments = ''
        switch (commandline -t)
        case "!"
          commandline -t ""
          commandline -f history-token-search-backward
        case "*"
          commandline -i '$'
        end
      '';
    
      # Set up vi mode and bind !! / !$
      fish_user_key_bindings = ''
        fish_vi_key_bindings
        bind -Minsert ! __history_previous_command
        bind -Minsert '$' __history_previous_command_arguments
      '';
    };
  };
}
