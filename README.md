# nvim-ginkgo

[![test](https://github.com/nvim-contrib/nvim-ginkgo/actions/workflows/test.yml/badge.svg)](https://github.com/nvim-contrib/nvim-ginkgo/actions/workflows/test.yml)
[![Release](https://img.shields.io/github/v/release/nvim-contrib/nvim-ginkgo?include_prereleases)](https://github.com/nvim-contrib/nvim-ginkgo/releases)
[![License](https://img.shields.io/github/license/nvim-contrib/nvim-ginkgo)](LICENSE)
[![Neovim](https://img.shields.io/badge/Neovim-0.9%2B-blueviolet?logo=neovim&logoColor=white)](https://neovim.io)
[![Neotest](https://img.shields.io/badge/neotest-adapter-green)](https://github.com/nvim-neotest/neotest)

A [Neotest](https://github.com/nvim-neotest/neotest) adapter for the [Ginkgo](https://github.com/onsi/ginkgo) BDD testing framework — run, navigate, and inspect your Go tests without leaving Neovim.

## Features

- Run individual specs, describe blocks, or entire suites from within Neovim
- Supports `Describe`, `Context`, `It`, `When`, `DescribeTable`, and `Entry`
- Nested test structures displayed in the Neotest tree
- DAP integration for debugging individual specs
- Output panel with structured test results
- Works with `lazy.nvim`, `packer.nvim`, and any other plugin manager

## Requirements

- Neovim >= 0.9
- [neotest](https://github.com/nvim-neotest/neotest)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with the `go` parser installed
- [nvim-nio](https://github.com/nvim-neotest/nvim-nio)
- [Ginkgo](https://github.com/onsi/ginkgo) (`go install github.com/onsi/ginkgo/v2/ginkgo@latest`)

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
    "nvim-contrib/nvim-ginkgo",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("nvim-ginkgo"),
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
    "nvim-contrib/nvim-ginkgo",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("nvim-ginkgo"),
      },
    })
  end,
}
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

Without Nix, update `spec/setup.lua` with the paths to your local plugin installations, then:

```bash
make test
```

## License

[MIT](LICENSE)
