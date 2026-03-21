# neotest-ginkgo

> [Neotest](https://github.com/nvim-neotest/neotest) adapter for running [Ginkgo v2](https://github.com/onsi/ginkgo) tests in Neovim. Run, debug, and inspect your Go BDD specs directly from the editor — with full support for nested `Describe`/`Context`/`When`/`It` hierarchies, `DescribeTable`/`Entry`, and DAP debugging via [nvim-dap-go](https://github.com/leoluz/nvim-dap-go).

[![test](https://github.com/nvim-contrib/neotest-ginkgo/actions/workflows/test.yml/badge.svg)](https://github.com/nvim-contrib/neotest-ginkgo/actions/workflows/test.yml)
[![Release](https://img.shields.io/github/v/release/nvim-contrib/neotest-ginkgo?include_prereleases)](https://github.com/nvim-contrib/neotest-ginkgo/releases)
[![License](https://img.shields.io/github/license/nvim-contrib/neotest-ginkgo)](LICENSE)
[![Neovim](https://img.shields.io/badge/Neovim-0.9%2B-blueviolet?logo=neovim&logoColor=white)](https://neovim.io)
[![Neotest](https://img.shields.io/badge/neotest-adapter-green)](https://github.com/nvim-neotest/neotest)

<img src="doc/tapes/output/demo.webp" alt="neotest-ginkgo demo" width="100%">

## Features

- Run individual specs, describe blocks, or entire suites
- Full Ginkgo v2 support: `Describe`, `Context`, `It`, `When`, `Specify`, `DescribeTable`, `DescribeTableSubtree`, and `Entry`
- Focus (`FDescribe`, `FIt`) and pending (`PDescribe`, `PIt`, `XIt`) variants
- Nested test hierarchy displayed in the Neotest summary tree
- DAP integration for step-through debugging of individual specs
- Structured output panel with color-coded test results
- Works with `lazy.nvim`, `packer.nvim`, and any other plugin manager

## Requirements

- Neovim >= 0.9
- [neotest](https://github.com/nvim-neotest/neotest)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with the `go` parser installed
- [nvim-nio](https://github.com/nvim-neotest/nvim-nio)
- [Ginkgo v2](https://github.com/onsi/ginkgo) (`go install github.com/onsi/ginkgo/v2/ginkgo@latest`)

## Installation

### lazy.nvim

```lua
{
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-contrib/neotest-ginkgo",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-ginkgo"),
      },
    })
  end,
}
```

### packer.nvim

```lua
use {
  "nvim-neotest/neotest",
  requires = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-contrib/neotest-ginkgo",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-ginkgo"),
      },
    })
  end,
}
```

## Configuration

You can customize the Ginkgo command and DAP arguments via `setup()`:

```lua
require("neotest-ginkgo").setup({
  -- Base ginkgo command (default: {"ginkgo", "run", "-v"})
  command = { "ginkgo", "run", "-v", "--race" },
  -- DAP arguments with --ginkgo. prefix (default: {"--ginkgo.v"})
  dap = { "--ginkgo.v", "--ginkgo.trace" },
})
```

## Usage

Use the standard Neotest keybindings to run tests. Example setup:

```lua
vim.keymap.set("n", "<leader>tt", function() require("neotest").run.run() end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run file" })
vim.keymap.set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle summary" })
vim.keymap.set("n", "<leader>to", function() require("neotest").output_panel.toggle() end, { desc = "Toggle output" })
vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, { desc = "Debug nearest test" })
```

## Contributing

Contributions are welcome! Please open an issue or pull request.

To set up a development environment with [Nix](https://nixos.org):

```bash
nix develop
make test
```

Without Nix, update `tests/setup.lua` with the paths to your local plugin installations, then:

```bash
make test
```

## License

[MIT](LICENSE)
