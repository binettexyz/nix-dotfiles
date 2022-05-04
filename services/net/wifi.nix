{ config, ... }: {

  networking.wireless = {
    userControlled.enable = true;
    networks = {
        # home
      "Hal" = {
        priority = 1;
  	  # psk = "2954Jardin";
	pskRaw = "af8dca01536bdf1b08911c118df5971defa78264c21a376fbc41e92f628b6a26";
      };

        # mother
      "DD-WRT" = {
        priority = 0;
        pskRaw = "ecae0b81eb975c57daa6222e7cf2278fd055f6172a7bfe64cf8340c620814364";
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
