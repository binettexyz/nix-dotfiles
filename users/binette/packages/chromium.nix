{ config, pkgs, ... }: {
  home-manager.users.binette.programs.chromium = {
    enable = true;
      # See available extensions at https://chrome.google.com/webstore/category/extensions
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "lckanjgmijmafbedllaakclkaicjfmnk"; } # ClearURLs
      { id = "ldpochfccmkkmhdbclfhpagapcfdljkj"; } # Decentraleyes
      { id = "ahjhlnckcgnoikkfkfnkbfengklhglpg"; } # Dictionary all over with Synonyms
      { id = "oocalimimngaihdkbihfgmpkcpnmlaoa"; } # Netflix Party (Teleparty)
      { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # Privacy Badger
      { id = "ocgpenflpmgnfapjedencafcfakcekcd"; } # Redirector
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock for YouTube
      { id = "gcbommkclmclpchllfjekcdonpmejbdp"; } # HTTPS Everywhere
      { id = "lcbjdhceifofjlpecfpeimnnphbcjgnc"; } # xBrowserSync
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # Tampermonkey
    ];
  };

}
