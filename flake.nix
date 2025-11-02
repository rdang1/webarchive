{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {
      devShells =
        nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ]
          (
            system:
            let
              pkgs = import nixpkgs { inherit system; };
            in
            {
              default = pkgs.mkShell {
                buildInputs = [
                  pkgs.wget
                  pkgs.python312
                  pkgs.python312Packages.beautifulsoup4
                  pkgs.monolith
                ];

                shellHook = ''
                  echo ${system}
                '';
              };
            }
          );
    };
}
