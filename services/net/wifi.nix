{ config, ... }: {

  networking.wireless = {
    userControlled.enable = true;
    networks = {
      # home
        "DD-WRT" = {
          priority = 0;
          pskRaw = "ecae0b81eb975c57daa6222e7cf2278fd055f6172a7bfe64cf8340c620814364";
        };

          # girlfriend's
        "VIDEOTRON4361" = {
          priority = 1;
	#psk="NF4NHFU4E7J4J"
	  pskRaw = "6295a743cc0873d712b7d3524ed091609208add77ebfead74f0be6496581357f";
        };

          # work
        "FONDATIONHBM" = {
          priority = 2;
          pskRaw = "6df6c695105bc76306832ba0643f9de718f72d8886e072605f5ef256f8df5542";
        };

          # phone's hotspot
        "bin-hotspot" = {
          hidden = true;
          priority = 3;
          pskRaw = "2855045c3fb78c87d82fca5761710f259cf7b4f20c5f022c5937349b9bf71707";
        };
    };
  };

}
