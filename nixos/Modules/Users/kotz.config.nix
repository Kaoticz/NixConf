{ ... }:

{
  users.users.kotz = {
    isNormalUser = true;
    description = "Kotz";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
}