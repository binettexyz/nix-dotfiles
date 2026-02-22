{
  flake.nixosModules.systemd = {
    systemd = {
      # Reduce default service stop timeouts for faster shutdown
      settings.Manager = {
        DefaultTimeoutStopSec = "15";
        DefaultTimeoutAbortSec = "5s";
      };
      # systemd's out-of-memory daemon
      oomd = {
        enable = true;
        enableRootSlice = true;
        enableSystemSlice = true;
        enableUserSlices = true;
      };
    };
  };
}
