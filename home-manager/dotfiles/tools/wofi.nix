{ ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      location = "center";
      width = 500;
      height = 300;
    };
    style = ''
      window {
        margin: 0px;
        border: 2px solid #504945;
        background-color: #282828;
      }

      #input {
        margin: 5px;
        border: none;
        color: #d4be98;
        background-color: #1d2021;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: #282828;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: #282828;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #d4be98;
      }

      #entry:selected {

        background-color: #1d2021;
      }
    '';
  };
}
