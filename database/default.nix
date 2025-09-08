lib:
let
  jsonFiles = builtins.attrNames (
    lib.filterAttrs (n: v: v == "regular" && lib.hasSuffix ".json" n) (builtins.readDir ./.)
  );
  entries = builtins.map (x: builtins.fromJSON (builtins.readFile (./. + "/${x}"))) jsonFiles;

  b01 = x: if x then "1" else "0";
  idOf =
    fingerprint:
    lib.concatStringsSep "" [
      (b01 fingerprint.canRepresentNegativeNan)
      (b01 fingerprint.firstNanPropagates)
      (b01 fingerprint.infMinusInfIsNegativeNan)
      (b01 fingerprint.isCaseInsensitiveFs)
    ];

  possibleSystems = builtins.foldl' (
    acc: elem:
    let
      id = idOf elem.fingerprint;
    in
    acc
    // {
      ${id} = lib.unique ((acc.${id} or [ ]) ++ [ elem.meta.currentSystem ]);
    }
  ) { } entries;
in
{
  inherit
    entries
    possibleSystems
    ;

  # Given a fingerprint, this returns a list of all known systems that have the same fingerprint.
  # If you find a system with a fingerprint that is not included here, please make a PR to add it!
  estimateSystemsFor = fingerprint: possibleSystems.${idOf fingerprint} or [ ];
}
