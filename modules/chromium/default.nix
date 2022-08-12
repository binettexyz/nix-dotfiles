{ config, pkgs, ... }: {

  programs.chromium = {
    enable = true;
    defaultSearchProviderSearchURL = "https://duckduckgo.com/?q=%s";
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock for YouTube
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "lckanjgmijmafbedllaakclkaicjfmnk" # ClearURLs
      "ldpochfccmkkmhdbclfhpagapcfdljkj" # Decentraleyes
      "ahjhlnckcgnoikkfkfnkbfengklhglpg" # Dictionary all over with Synonyms
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
      "ocgpenflpmgnfapjedencafcfakcekcd" # Redirector
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock for YouTube
      "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
      "lcbjdhceifofjlpecfpeimnnphbcjgnc" # xBrowserSync
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
      "dhdgffkkebhmkfjojejmpbldmpobfkfo" # Tampermonkey
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
    ];
      # See available options at https://chromeenterprise.google/policies/
    extraOpts = {
      "BrowserSignin" = 0;
      "BrowserAddPersonEnabled" = false;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;
      "BuiltInDnsClientEnabled" = false;
      "MetricsReportingEnabled" = false;
      "SearchSuggestEnabled" = false;
      "AlternateErrorPagesEnabled" = false;
      "UrlKeyedAnonymizedDataCollectionEnabled" = false;
      "SpellcheckEnabled" = false;
      "CloudPrintSubmitEnabled" = false;
      "BlockThirdPartyCookies" = true;
      "AutoplayAllowed" = false;
      "HomepageIsNewTabPage" = false;
    };
  };

}
