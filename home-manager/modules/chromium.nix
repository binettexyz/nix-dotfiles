{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.hm.browser.chromium;
in {

  options.modules.hm.browser.chromium.enable = mkOption {
    description = "Enable chromium";
    default = false;
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "lckanjgmijmafbedllaakclkaicjfmnk"; } # ClearURLs
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
        { id = "ldpochfccmkkmhdbclfhpagapcfdljkj"; } # Decentraleyes
        { id = "ahjhlnckcgnoikkfkfnkbfengklhglpg"; } # Dictionary all over with Synonyms
        { id = "cmeckkgeamghjhkepejgjockldoblhcb"; } # Export links of all extensions
        { id = "gcbommkclmclpchllfjekcdonpmejbdp"; } # HTTPS Everywhere
        { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # Privacy Badger
        { id = "ocgpenflpmgnfapjedencafcfakcekcd"; } # Redirector
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock for YouTube
        { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # Stylus
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
        { id = "jinjaccalgkegednnccohejagnlnfdag"; } # Violent Monkey
        { id = "lcbjdhceifofjlpecfpeimnnphbcjgnc"; } # xBrowserSync
        {
            # chromium web store
          id = "ocaahdebbfolfmndjeplogmgcagdmblk";
          crxPath = builtins.fetchurl {
            name = "chromium-web-store.crx";
            url = "https://github.com/NeverDecaf/chromium-web-store/releases/download/v1.4.0/Chromium.Web.Store.crx";
            sha256 = "1bfzd02a9krkapkbj51kxfp4a1q5x2m2pz5kv98ywfcarbivskgs";
          };
          version = "1.4.0";
        }
      ];
    };
  };

}
