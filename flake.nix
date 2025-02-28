{ 
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };
  outputs = {
    nixpkgs,
    ...
  }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    apps.${system} = {
      manageSecrets = {
        type = "app";
        program = let
          manageSecretsApp = pkgs.writeShellApplication {
            name = "manageSecrets";
            runtimeInputs = [pkgs.git];
            text = builtins.readFile ./scripts/secret_management.sh;
          };
        in
        "${manageSecretsApp}/bin/manageSecrets";
      };
    };
  };
}
