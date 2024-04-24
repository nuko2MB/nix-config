# Common settings for gaming
{ lib, ... }@args:
lib.nuko.mkModule args "gaming" {
  # TODO
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };
}
