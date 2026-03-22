# Changelog

## [0.3.2](https://github.com/nvim-contrib/neotest-ginkgo/compare/v0.3.1...v0.3.2) (2026-03-22)


### Bug Fixes

* correct paths in demo tape files and README ([86f5a56](https://github.com/nvim-contrib/neotest-ginkgo/commit/86f5a5627d57a6e5327e309702322b5208b27265))

## [0.3.1](https://github.com/nvim-contrib/neotest-ginkgo/compare/v0.3.0...v0.3.1) (2026-03-13)


### Bug Fixes

* use --output-dir to write JSON report to temp directory ([0165184](https://github.com/nvim-contrib/neotest-ginkgo/commit/0165184811394acdb8f23c5e2033fdfe43ad8a29))

## [0.3.0](https://github.com/nvim-contrib/neotest-ginkgo/compare/v0.2.0...v0.3.0) (2026-03-12)


### ⚠ BREAKING CHANGES

* Renamed from nvim-ginkgo to neotest-ginkgo. Update your config: "nvim-contrib/neotest-ginkgo" and require("neotest-ginkgo").

### Code Refactoring

* rename nvim-ginkgo to neotest-ginkgo ([aef8ef6](https://github.com/nvim-contrib/neotest-ginkgo/commit/aef8ef641cd118803f8fb97eb8032e712a2a6035))

## [0.2.0](https://github.com/nvim-contrib/nvim-ginkgo/compare/v0.1.0...v0.2.0) (2026-03-11)


### Features

* **adapter:** return adapter and add completion comment ([9ffe211](https://github.com/nvim-contrib/nvim-ginkgo/commit/9ffe2114342b1581db9d3c287840c88252712154))
* **dap:** add DAP support for Ginkgo test debugging ([e061fb9](https://github.com/nvim-contrib/nvim-ginkgo/commit/e061fb955294a85c8f078fa6b59c93759d0ae14e))
* **ginkgo:** enhance filter_dir to check for test suite files ([b54c2ca](https://github.com/nvim-contrib/nvim-ginkgo/commit/b54c2caef35f68a73f947b3d2bbde0ed4438e8d5))
* **output:** enhance ginkgo test output with captured stdout/stderr ([98d537d](https://github.com/nvim-contrib/nvim-ginkgo/commit/98d537d34e90b1645aa89c5ff5ba59646a35214c))
* **queries:** add DescribeTable function variants to ginkgo namespace query ([e2e549f](https://github.com/nvim-contrib/nvim-ginkgo/commit/e2e549fdc7b0355535a073c2d1e943edcb3d92f6))
* **queries:** add Ginkgo table subtree and entry test definitions ([ca0ad97](https://github.com/nvim-contrib/nvim-ginkgo/commit/ca0ad972d0c03c0f98503d91f29b726cb78f4fba))
* **report:** improve test namespace result tracking and summary generation ([84e8e18](https://github.com/nvim-contrib/nvim-ginkgo/commit/84e8e18febf7ea41e33f18e19243d8d2ca227b22))
* **spec,dap:** add configurable command and debug arguments ([e6fd707](https://github.com/nvim-contrib/nvim-ginkgo/commit/e6fd707f60fc8e010203ded5d44a05a197ffc466))
* **tree-sitter:** add Entry node support in Ginkgo test parsing ([4bce787](https://github.com/nvim-contrib/nvim-ginkgo/commit/4bce7871a49a0c7a1e7deddf246bbe2d5ecf6121))
* **tree:** implement Ginkgo test parsing for neotest ([7b84c62](https://github.com/nvim-contrib/nvim-ginkgo/commit/7b84c6220486b99ad672baed1256bbd05242655b))


### Bug Fixes

* **adapter:** handle missing captured output for spec items ([052c18a](https://github.com/nvim-contrib/nvim-ginkgo/commit/052c18a7f3a36ae775611c7497eac0ba55f34ba9))
* **flake:** set rtp via customRC so plugins load with --noplugin ([96b6da3](https://github.com/nvim-contrib/nvim-ginkgo/commit/96b6da3b2bf4b69761ce2ffcb5c55bf7784ef8a7))
* **flake:** use nvim wrapper script to inject plugin rtp via --cmd ([5285a3a](https://github.com/nvim-contrib/nvim-ginkgo/commit/5285a3ac8c3d3fac11a16b4d06eda5eeb15f51a6))
* **report:** handle Entry nodes, suite failure status, and clarify output param ([882325f](https://github.com/nvim-contrib/nvim-ginkgo/commit/882325f012e9cf338a8bbd4e7a1a5950fd7dadf2))
* **report:** set empty string for no output captured ([3dcbaab](https://github.com/nvim-contrib/nvim-ginkgo/commit/3dcbaab2a04b463d1444ccbcf50a5972f4636a6c))
* **spec:** set cwd and use relative package path in RunSpec ([f1b84dd](https://github.com/nvim-contrib/nvim-ginkgo/commit/f1b84dd835cbb41719aec26e5bc6fbe0e8f01794))
* **test:** fix CI test environment for nix devshell ([13ff31f](https://github.com/nvim-contrib/nvim-ginkgo/commit/13ff31ff8f010f37718b3e1b94a6d3fac5e0ba2a))
