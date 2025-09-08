let
  evalToml = x: (builtins.fromTOML "a = ${x}").a;
  posnan = evalToml "nan";
in
{
  # only in impure mode, e.g. nix repl, causes nix to exit immediately
  triggerExit = builtins.storePath "/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

  # How to catch? tryEval only catches builtins.throw
  errorsOnGccOnly = builtins.match ''\1'' "";

  # nix versions <=2.31 (possible newer versions too) have a bug in nan comparison
  nanGeImmediate = posnan >= 1;
  nanLeImmediate = posnan <= 1;

  # Darwin issue: crashes on aarch64-darwin, works on aarch64-linux
  subnorm = evalToml "1e-308";
}
