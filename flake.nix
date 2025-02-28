{ 
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };
  outputs = {
    nixpkgs,
    config,
  }:
  let
    system = "x86-64_linux";
    pkgs = nixpkgs.legacyPackages.${system};
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
  }
}
