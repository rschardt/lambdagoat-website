{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs, ...}: rec {
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages."${system}";

    devShells."${system}".default = pkgs.mkShell {
      packages = with pkgs; [
        hugo
      ];
    };

    apps."${system}" = {
      default = {
        type = "app";
        program = let
          runHugoDevServer = pkgs.writeShellScriptBin "runHugoDevServer" ''
            "${pkgs.hugo}/bin/hugo" server -DEF
          '';
        in
          "${runHugoDevServer}/bin/runHugoDevServer";
      };

      prod = {
        type = "app";
        program = let
          runHugoProdServer = pkgs.writeShellScriptBin "runHugoProdServer" ''
            "${pkgs.hugo}/bin/hugo" server -DEF
          '';
        in
          "${runHugoProdServer}/bin/runHugoProdServer";
      };
    };
  };
}
