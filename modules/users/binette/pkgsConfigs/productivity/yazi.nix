{
  flake.modules.homeManager.binetteYazi = {
    programs.yazi = {
      enable = true;
      settings = {
        mgr = {
          ratio = [
            1
            4
            3
          ];
          sort_by = "alphabetical";
          sort_sensitive = false;
          sort_reverse = false;
          sort_dir_first = true;
          sort_translit = false;
          linemode = "mtime";
          show_hidden = true;
          show_symlink = true;
        };
        preview = {
          wrap = "no";
          tab_size = 2;
          max_width = 600;
          max_height = 900;
          cache_dir = "";
          image_delay = 30;
          image_filter = "triangle";
          image_quality = 75;
          sixel_fraction = 15;
          ueberzug_scale = 1;
          ueberzug_offset = [
            0
            0
            0
            0
          ];
        };
        opener = {
          edit = [
            {
              run = ''''${EDITOR:-nvim} "$@"'';
              desc = "$EDITOR";
              block = true;
              for = "unix";
            }
          ];
          open = [
            {
              run = ''xdg-open "$1"'';
              desc = "Open";
              for = "linux";
            }
          ];
          reveal = [
            {
              run = ''xdg-open "$(dirname "$1")"'';
              desc = "Reveal";
              for = "linux";
            }
          ];
          extract = [
            {
              run = ''ya pub extract --list "$@"'';
              desc = "Extract here";
              for = "unix";
            }
          ];
          play = [
            {
              run = ''mpv --force-window "$@"'';
              orphan = true;
              for = "unix";
            }
          ];
        };
        open.rules = [
          # Folder
          {
            name = "*/";
            use = [
              "edit"
              "open"
              "reveal"
            ];
          }
          # Text
          {
            mime = "text/*";
            use = [
              "edit"
              "reveal"
            ];
          }
          # Image
          {
            mime = "image/*";
            use = [
              "open"
              "reveal"
            ];
          }
          # Media
          {
            mime = "{audio,video}/*";
            use = [
              "play"
              "reveal"
            ];
          }
          # Archive
          {
            mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
            use = [
              "extract"
              "reveal"
            ];
          }
          # JSON
          {
            mime = "application/{json,ndjson}";
            use = [
              "edit"
              "reveal"
            ];
          }
          {
            mime = "*/javascript";
            use = [
              "edit"
              "reveal"
            ];
          }
          # Empty file
          {
            mime = "inode/empty";
            use = [
              "edit"
              "reveal"
            ];
          }
          # Fallback
          {
            name = "*";
            use = [
              "open"
              "reveal"
            ];
          }
        ];
      };
      keymap =
        let
          keymap = on: run: desc: { inherit on run desc; };
        in
        {
          mgr.keymap = [
            # Navigation
            (keymap "k" "arrow prev" "Previous file")
            (keymap "j" "arrow next" "Next file")
            (keymap "h" "leave" "Back to the parent directory")
            (keymap "l" "enter" "Enter the child directory")
            (keymap [ "g" "g" ] "arrow top" "Go to top")
            (keymap "G" "arrow bot" "Go to bottom")

            # Goto
            (keymap [ "g" "h" ] "cd ~" "Go Home")
            (keymap [ "g" "d" ] "cd ~/documents" "Go ~/documents")
            (keymap [ "g" "p" ] "cd ~/pictures" "Go ~/pictures")
            (keymap [ "g" "n" ] "cd /etc/nixos" "Go NixOS config")
            (keymap [ "g" "<Space>" ] "cd --interactive" "Jump interactively")
            (keymap [ "g" "f" ] "follow" "Follow hovered symlink")

            # Toggle
            (keymap "<Space>" [ "toggle" "arrow next" ] "Toggle the current selection state")
            (keymap "<C-a>" "toggle_all --state=on" "Select all files")
            (keymap "<C-r>" "toggle_all" "Invert selection of all files")

            # Operation
            (keymap "y" "yank" "Yank selected files (copy)")
            (keymap "x" "yank --cut" "Yank selected files (cut)")
            (keymap "Y" "unyank" "Cancel the yank status")
            (keymap "X" "unyank" "Cancel the yank status")
            (keymap "p" "paste" "Paste yanked files")
            (keymap "o" "open" "Open selected files")
            (keymap "<Enter>" "open" "Open selected files")
            (keymap "y" "yank" "Yank selected files (copy)")
            (keymap "x" "yank --cut" "Yank selected files (cut)")
            (keymap "p" "paste" "Paste yanked files")
            (keymap "d" "remove" "Trash selected files")
            (keymap "D" "remove --permanently" "Permanently delete selected files")
            (keymap "a" "create" "Create a file (ends with / for directories)")
            (keymap "r" "rename --cursor=before_ext" "Rename selected file(s)")
            (keymap "s" "search --via=fd" "Search files by name via fd")
            (keymap "S" "search --via=rg" "Search files by content via ripgrep")
            (keymap "<C-s>" "escape --search" "Cancel the ongoing search")
            (keymap "z" "plugin fzf" "Jump to a file/directory via fzf")
            (keymap "Z" "plugin zoxide" "Jump to a directory via zoxide")

            (keymap "<Esc>" "escape" "Exit visual mode, clear selection, or cancel search")
            (keymap "q" "quit" "Quit the process")
            (keymap "<C-c>" "close" "Close the current tab, or quit if it's last")

            # Sorting
            (keymap [ "," "m" ] [ "sort mtime --reverse=no" "linemode mtime" ] "Sort by modified time")
            (keymap [ "," "M" ] [ "sort mtime --reverse" "linemode mtime" ] "Sort by modified time (reverse)")
            (keymap [ "," "e" ] "sort extension --reverse=no" "Sort by extension")
            (keymap [ "," "E" ] "sort extension --reverse" "Sort by extension (reverse)")
            (keymap [ "," "a" ] "sort alphabetical --reverse=no" "Sort alphabetically")
            (keymap [ "," "A" ] "sort alphabetical --reverse" "Sort alphabetically (reverse)")
            (keymap [ "," "n" ] "sort natural --reverse=no" "Sort naturally")
            (keymap [ "," "N" ] "sort natural --reverse" "Sort naturally (reverse)")
            (keymap [ "," "s" ] [ "sort size --reverse=no" "linemode size" ] "Sort by size")
            (keymap [ "," "S" ] [ "sort size --reverse" "linemode size" ] "Sort by size (reverse)")
          ];
        };
    };
  };
}
