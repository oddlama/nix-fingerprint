let
  evalToml = x: (builtins.fromTOML "a = ${x}").a;

  posnan = evalToml "nan";
  negnan = evalToml "-nan";

  isCaseInsensitiveFs = builtins.pathExists (
    (builtins.substring 0 44 (builtins.toFile "Aa" "")) + "aa"
  );

  canRepresentNegativeNan = builtins.substring 0 1 (toString negnan) == "-";

  # inf - inf is -nan on some systems, nan on others
  infMinusInfIsNegativeNan =
    builtins.substring 0 1 (toString (1.0e200 * 1.0e200 - 1.0e200 * 1.0e200)) == "-";

  # whether a + b propagates a if both are nan
  firstNanPropagates =
    canRepresentNegativeNan && builtins.substring 0 1 (toString (negnan + posnan)) == "-";
in
{
  inherit
    isCaseInsensitiveFs
    canRepresentNegativeNan
    infMinusInfIsNegativeNan
    firstNanPropagates
    ;
}
