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

        # Wrapper script named "nvim" that injects plugin rtp entries via
        # --cmd before any other arguments, so plugins are findable even
        # when the caller uses --noplugin (as make test does).
        neovimForTests = pkgs.writeShellScriptBin "nvim" ''
          exec ${pkgs.neovim}/bin/nvim \
            ${pkgs.lib.concatMapStringsSep " \\\n            "
              (p: "--cmd \"set runtimepath^=${p}\"")
              plugins} \
            "$@"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            neovimForTests
            pkgs.go
            pkgs.ginkgo
          ];
        };
      });
}
