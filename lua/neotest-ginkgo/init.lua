local lib = require("neotest.lib")
local plenary = require("plenary.path")
local tree = require("neotest-ginkgo.tree")
local spec = require("neotest-ginkgo.spec")
local report = require("neotest-ginkgo.report")
local dap = require("neotest-ginkgo.dap")

---@class neotest.Adapter
---@field name string
local adapter = { name = "neotest-ginkgo" }

---Find the project root directory given a current directory to work from.
---Should no root be found, the adapter can still be used in a non-project context if a test file matches.
---@async
---@return string | nil @Absolute root dir of test suite
adapter.root = lib.files.match_root_pattern("go.mod", "go.sum")

---Setup the adapter with custom configuration
---@param config table|nil Configuration with optional fields:
---  - command (string[]): Ginkgo command arguments
---  - dap (string[]): DAP debugging arguments with --ginkgo. prefix
function adapter.setup(config)
	config = config or {}
	-- Setup the spec
	spec.setup(config.command)
	-- Setup the dap
	dap.setup(config.dap)
	-- done
	return adapter
end

---Filter directories when searching for test files
---@async
---@param name string Name of directory
---@param rel_path string Path to directory, relative to root
---@param root string Root directory of project
---@return boolean
function adapter.filter_dir(name, rel_path, root)
	if name == "vendor" then
		return false
	end
	local dir_path = root .. plenary.path.sep .. rel_path
	local suite_file = dir_path .. plenary.path.sep .. "suite_test.go"
	local named_suite_file = dir_path .. plenary.path.sep .. name .. "_suite_test.go"
	if vim.fn.filereadable(suite_file) == 1 or vim.fn.filereadable(named_suite_file) == 1 then
		return true
	end
	-- Allow intermediate directories that contain suite files deeper in the tree
	return #vim.fn.glob(dir_path .. "/**/suite_test.go", false, true) > 0
		or #vim.fn.glob(dir_path .. "/**/*_suite_test.go", false, true) > 0
end

---@async
---@param file_path string
---@return boolean
function adapter.is_test_file(file_path)
	if not vim.endswith(file_path, ".go") or vim.endswith(file_path, "suite_test.go") then
		return false
	end

	local file_path_segments = vim.split(file_path, plenary.path.sep)
	local file_path_basename = file_path_segments[#file_path_segments]
	return vim.endswith(file_path_basename, "_test.go")
end

---Given a file path, parse all the tests within it.
---@async
---@param file_path string Absolute file path
---@return neotest.Tree | nil
function adapter.discover_positions(file_path)
	return tree.parse_positions(file_path)
end

---@param args neotest.RunArgs
---@return nil | neotest.RunSpec | neotest.RunSpec[]
function adapter.build_spec(args)
	local run_spec = spec.build(args)

	-- If DAP strategy is requested, enhance the spec with DAP configuration
	if args.strategy == "dap" then
		run_spec.strategy = dap.build(run_spec.context)
	end

	return run_spec
end

---@async
---@param spec neotest.RunSpec
---@param result neotest.StrategyResult
---@param tree neotest.Tree
---@return table<string, neotest.Result>
function adapter.results(spec, result, tree)
	return report.parse(spec, result, tree)
end

--the adatper
return adapter
