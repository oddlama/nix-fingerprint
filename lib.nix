rec {
  evalToml = x: (builtins.fromTOML "a = ${x}").a;

  isCaseInsensitiveFs = builtins.pathExists (
    (builtins.substring 0 44 (builtins.toFile "Aa" "")) + "aa"
  );
  isX86 = builtins.substring 0 1 (builtins.toString (1.0e200 * 1.0e200 - 1.0e200 * 1.0e200)) == "-";

  # only in impure mode, e.g. nix repl
  triggerCrash = builtins.storePath "/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

  # How to catch? tryEval only catches builtins.throw
  errorsOnGccOnly = builtins.match ''\1'' "";

  # A rough estimation of the current system
  estimatedCurrentSystem =
    let
      sys = if isX86 then "x86_64" else "aarch64";
      os = if isCaseInsensitiveFs then "darwin" else "linux";
    in
    "${sys}-${os}";

  posnan = evalToml "nan";
  negnan = evalToml "-nan";
  posinf = evalToml "inf";
  neginf = evalToml "-inf";
  subnorm = evalToml "1.0e-308";

  firstNanPropagates = builtins.substring 0 1 (builtins.toString (negnan + posnan)) == "-";
}
