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

        plugins = with pkgs.vimPlugins; [
          plenary-nvim
          nvim-treesitter
          nvim-nio
          neotest
        ];

        neovimWithPlugins = pkgs.neovim.override {
          configure = {
            # Set rtp directly in sysinit.vim so plugins are findable
            # even when neovim is invoked with --noplugin (as in make test)
            customRC = pkgs.lib.concatMapStringsSep "\n"
              (p: "set runtimepath^=${p}")
              plugins;
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
