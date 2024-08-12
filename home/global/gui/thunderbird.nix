{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    profiles = {
      "Main gmail" = {
        isDefault = true;
      };
    };
  };

  accounts.email.accounts."Main gmail" = {   
    primary = true;
    address = "jonathan.s.scherrer@gmail.com";
    realName = "Jonathan Scherrer";
    thunderbird.enable = true;
  };
}
