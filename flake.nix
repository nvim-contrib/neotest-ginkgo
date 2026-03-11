{
  description = "nvim-ginkgo - neotest adapter for Ginkgo test framework";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        neovimWithPlugins = pkgs.neovim.override {
          configure = {
            packages.nvimGinkgo.start = with pkgs.vimPlugins; [
              plenary-nvim
              nvim-treesitter
              nvim-nio
              neotest
            ];
          };
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            neovimWithPlugins
            go
            ginkgo
          ];
        };
      });
}
