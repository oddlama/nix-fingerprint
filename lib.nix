rec {
  evalToml = x: (builtins.fromTOML "a = ${x}").a;

  isCaseInsensitiveFs = builtins.pathExists (
    (builtins.substring 0 44 (builtins.toFile "Aa" "")) + "aa"
  );

  canRepresentNegativeNan = builtins.substring 0 1 negnan == "-";

  # inf - inf is -nan on some systems, nan on others
  infMinusInfIsNegativeNan =
    builtins.substring 0 1 (builtins.toString (1.0e200 * 1.0e200 - 1.0e200 * 1.0e200)) == "-";

  # whether a + b propagates a if both are nan
  firstNanPropagates =
    canRepresentNegativeNan && builtins.substring 0 1 (builtins.toString (negnan + posnan)) == "-";

  # only in impure mode, e.g. nix repl, causes nix to exit immediately
  triggerExit = builtins.storePath "/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

  # How to catch? tryEval only catches builtins.throw
  errorsOnGccOnly = builtins.match ''\1'' "";

  # A rough estimation of the current system
  estimatedCurrentSystem =
    let
      sys = if infMinusInfIsNegativeNan then "x86_64" else "aarch64";
      os = if isCaseInsensitiveFs then "darwin" else "linux";
    in
    "${sys}-${os}";

  posnan = evalToml "nan";
  negnan = evalToml "-nan";
  posinf = evalToml "inf";
  neginf = evalToml "-inf";

  # Darwin issue: crashes on aarch64-darwin, works on aarch64-linux
  subnorm = evalToml "1e-308";
}
