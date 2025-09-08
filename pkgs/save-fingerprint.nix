{
  writeShellApplication,
  nix,
  jq,
}:

writeShellApplication {
  name = "save-fingerprint";
  runtimeInputs = [
    nix
    jq
  ];
  text = ''
    nix_version=$(nix eval --raw --expr 'builtins.nixVersion')
    current_system=$(nix eval --impure --raw --expr 'builtins.currentSystem')

    export nix_version current_system

    function fingerprint() {
      nix eval --json --file ${../lib/fingerprint.nix} \
        | jq '{ fingerprint: ., meta: { nixVersion: env.nix_version, currentSystem: env.current_system } }'
    }

    if [[ "''${1-}" == "--stdout" ]]; then
      fingerprint
    else
      fingerprint > "database/fingerprint-$current_system-nix-$nix_version.json"
    fi
  '';
}
