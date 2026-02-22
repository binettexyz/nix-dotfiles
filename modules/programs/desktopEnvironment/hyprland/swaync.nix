{
  flake.modules.homeManager.swaync = {
    services.swaync = {
      enable = true;
      #settings = {};
      style = ''
        * {
          all: unset;
          font-size: 14px;
          font-weight: 600;
          font-family: monospace;
          transition: 200ms;
        }

        .floating-notifications.background .notification-row .notification-background {
          box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px #1d2021;
          border-radius: 12.6px;
          margin: 18px;
          background-color: #282828;
          color: #d4be98;
          padding: 0;
        }

        .floating-notifications.background .notification-row .notification-background .notification {
          padding: 7px;
          border-radius: 12.6px;
        }

        .floating-notifications.background .notification-row .notification-background .notification.critical {
          box-shadow: inset 0 0 7px 0 #ea6962;
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content {
          margin: 7px;
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content .summary {
          color: #d4be98;
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content .time {
          color: #7daea3;
        }

        .floating-notifications.background .notification-row .notification-background .notification .notification-content .body {
          color: #d4be98;
        }

        .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * {
          min-height: 3.4em;
        }

        .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action {
          border-radius: 7px;
          color: #d4be98;
          background-color: #1d2021;
          box-shadow: inset 0 0 0 1px #3c3836;
          margin: 7px;
        }

        .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
          box-shadow: inset 0 0 0 1px #3c3836;
          background-color: #1d2021;
          color: #d4be98;
        }

        .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
          box-shadow: inset 0 0 0 1px #3c3836;
          background-color: #83a598;
          color: #d4be98;
        }

        .floating-notifications.background .notification-row .notification-background .close-button {
          margin: 7px;
          padding: 2px;
          border-radius: 6.3px;
          color: #282828;
          background-color: #ea6962;
        }

        .floating-notifications.background .notification-row .notification-background .close-button:hover {
          background-color: #d4be98;
          color: #282828;
        }

        .floating-notifications.background .notification-row .notification-background .close-button:active {
          background-color: #ea6962;
          color: #282828;
        }

        .control-center {
          box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px #1d2021;
          border-radius: 12.6px;
          margin: 18px;
          background-color: #282828;
          color: #d4be98;
          padding: 14px;
        }

        .control-center .widget-title {
          color: #d4be98;
          font-size: 1.3em;
        }

        .control-center .widget-title button {
          border-radius: 7px;
          color: #d4be98;
          background-color: #1d2021;
          box-shadow: inset 0 0 0 1px #3c3836;
          padding: 8px;
        }

        .control-center .widget-title button:hover {
          box-shadow: inset 0 0 0 1px #3c3836;
          background-color: #a9b665;
          color: #141617;
        }

        .control-center .widget-title button:active {
          box-shadow: inset 0 0 0 1px #3c3836;
          background-color: #83a598;
          color: #282828;
        }

        .control-center .notification-row .notification-background {
          border-radius: 7px;
          color: #d4be98;
          background-color: #1d2021;
          box-shadow: inset 0 0 0 1px #3c3836;
          margin-top: 14px;
        }

        .control-center .notification-row .notification-background .notification {
          padding: 7px;
          border-radius: 7px;
        }

        .control-center .notification-row .notification-background .notification.critical {
          box-shadow: inset 0 0 7px 0 #ea6962;
        }

        .control-center .notification-row .notification-background .notification .notification-content {
          margin: 7px;
        }

        .control-center .notification-row .notification-background .notification .notification-content .summary {
          color: #d4be98;
        }

        .control-center .notification-row .notification-background .notification .notification-content .time {
          color: #7daea3;
        }

        .control-center .notification-row .notification-background .notification .notification-content .body {
          color: #d4be98;
        }

        .control-center .notification-row .notification-background .notification > *:last-child > * {
          min-height: 3.4em;
        }

        .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action {
          border-radius: 7px;
          color: #d4be98;
          background-color: #11111b;
          box-shadow: inset 0 0 0 1px #3c3836;
          margin: 7px;
        }

        .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
          box-shadow: inset 0 0 0 1px #3c3836;
          background-color: #1d2021;
          color: #d4be98;
        }

        .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
          box-shadow: inset 0 0 0 1px #3c3836;
          background-color: #83a598;
          color: #d4be98;
        }

        .control-center .notification-row .notification-background .close-button {
          margin: 7px;
          padding: 2px;
          border-radius: 6.3px;
          color: #282828;
          background-color: #d4be98;
        }

        .control-center .notification-row .notification-background .close-button:hover {
          background-color: #ea6962;
          color: #282828;
        }

        .control-center .notification-row .notification-background .close-button:active {
          background-color: #ea6962;
          color: #282828;
        }

        .control-center .notification-row .notification-background:hover {
          box-shadow: inset 0 0 0 1px #3c3836;
          background-color: #458588;
          color: #d4be98;
        }

        .control-center .notification-row .notification-background:active {
          box-shadow: inset 0 0 0 1px #3c3836;
          background-color: #83a598;
          color: #d4be98;
        }

        progressbar,
        progress,
        trough {
          border-radius: 12.6px;
        }

        progressbar {
          box-shadow: inset 0 0 0 1px #3c3836;
        }

        .notification.critical progress {
          background-color: #ea6962;
        }

        .notification.low progress,
        .notification.normal progress {
          background-color: #458588;
        }

        trough {
          background-color: #1d2021;
        }

        .control-center trough {
          background-color: #3c3836;
        }

        .control-center-dnd {
          margin-top: 5px;
          border-radius: 8px;
          background: #1d2021;
          border: 1px solid #3c3836;
          box-shadow: none;
        }

        .control-center-dnd:checked {
          background: #1d2021;
        }

        .control-center-dnd slider {
          background: #3c3836;
          border-radius: 8px;
        }

        .widget-dnd {
          margin: 0px;
          font-size: 1.1rem;
        }

        .widget-dnd > switch {
          font-size: initial;
          border-radius: 8px;
          background: #1d2021;
          border: 1px solid #3c3836;
          box-shadow: none;
        }

        .widget-dnd > switch:checked {
          background: #1d2021;
        }

        .widget-dnd > switch slider {
          background: #3c3836;
          border-radius: 8px;
          border: 1px solid #d65d0e;
        }
      '';
    };
  };
}
