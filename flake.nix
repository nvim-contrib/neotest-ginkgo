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
          nvim-treesitter-parsers.go
          nvim-nio
          neotest
        ];

        # LUA_PATH is exported as an environment variable so it is inherited
        # by child nvim processes that plenary spawns via v:progpath (which
        # resolves to the bare neovim-unwrapped binary, bypassing this wrapper).
        # neovim's require() checks LUA_PATH before its rtp-based loader, so
        # plugin modules are found in both the parent and all child processes.
        # --cmd "set runtimepath^=..." is also passed for the current process so
        # that vim.cmd.runtime() and other rtp-dependent calls work in the parent.
        luaPathEntries = pkgs.lib.concatStringsSep ";" (
          pkgs.lib.flatten (map (p: [ "${p}/lua/?.lua" "${p}/lua/?/init.lua" ]) plugins)
        );

        neovimForTests = pkgs.writeShellScriptBin "nvim" ''
          export LUA_PATH="${luaPathEntries};''${LUA_PATH:-}"
          exec ${pkgs.neovim}/bin/nvim \
            ${pkgs.lib.concatMapStringsSep " \\\n            "
              (p: "--cmd \"set runtimepath^=${p}\"")
              plugins} \
            "$@"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            neovimForTests
            go
            ginkgo
          ];
        };
      });
}
