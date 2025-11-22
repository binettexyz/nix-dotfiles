{ lib }:
{
  # Function for .css that expect an alpha value from 0 - 1
  # Inputs: hexColor is a string like "#RRGGBB", opacity is a float between 0 and 1
  # use it like this in a string:
  # hexToRgba = import ../../../../lib/hex2rgba.nix { inherit lib; };
  # ${hexToRgba { hexColor = #000000; opacity = 0.96; }};
  hexColor,
  opacity,
}:
let
  # Remove the leading '#' and convert to uppercase for consistency
  cleanHex = lib.removePrefix "#" (lib.toUpper hexColor);

  # Convert a two-character hex string to decimal
  hexToDec = hexStr: lib.fromHexString hexStr;

  # Extract RGB components
  r = hexToDec (lib.substring 0 2 cleanHex);
  g = hexToDec (lib.substring 2 2 cleanHex);
  b = hexToDec (lib.substring 4 2 cleanHex);

  # Manually format the opacity to two decimal places
  formattedOpacity = builtins.substring 0 4 (builtins.toString opacity);
in
# Construct the rgba string
"rgba(${toString r}, ${toString g}, ${toString b}, ${formattedOpacity})"
