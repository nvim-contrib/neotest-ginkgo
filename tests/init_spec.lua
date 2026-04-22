-- Tests for init.lua (adapter interface)

---@diagnostic disable: undefined-field

local nio_tests = require("nio.tests")
local async = require("neotest.async")
local adapter = require("neotest-ginkgo")

---Create a directory tree and return its root path
---@param structure table<string, string|boolean> Map of relative paths to content (string) or dir (true)
---@return string Root temp directory
local function make_dir_tree(structure)
	local root = async.fn.tempname()
	vim.fn.mkdir(root, "p")
	for rel, content in pairs(structure) do
		local full = root .. "/" .. rel
		local dir = vim.fn.fnamemodify(full, ":h")
		vim.fn.mkdir(dir, "p")
		if type(content) == "string" then
			vim.fn.writefile({ content }, full)
		end
	end
	return root
end

describe("adapter.filter_dir", function()
	nio_tests.it("returns true for directory with suite_test.go", function()
		local root = make_dir_tree({
			["pkg/suite_test.go"] = "package pkg_test",
		})

		assert.is_true(adapter.filter_dir("pkg", "pkg", root))

		async.fn.delete(root, "rf")
	end)

	nio_tests.it("returns true for directory with {name}_suite_test.go", function()
		local root = make_dir_tree({
			["service/service_suite_test.go"] = "package service_test",
		})

		assert.is_true(adapter.filter_dir("service", "service", root))

		async.fn.delete(root, "rf")
	end)

	nio_tests.it("returns true for intermediate directory containing suite files deeper", function()
		local root = make_dir_tree({
			["internal/database/pg/suite_test.go"] = "package pg_test",
		})

		-- internal/ has no suite file directly, but contains one in a subdirectory
		assert.is_true(adapter.filter_dir("internal", "internal", root))
		assert.is_true(adapter.filter_dir("database", "internal/database", root))

		async.fn.delete(root, "rf")
	end)

	nio_tests.it("returns false for directory with no suite files", function()
		local root = make_dir_tree({
			["cmd/main.go"] = "package main",
		})

		assert.is_false(adapter.filter_dir("cmd", "cmd", root))

		async.fn.delete(root, "rf")
	end)

	nio_tests.it("returns false for vendor directory", function()
		local root = make_dir_tree({
			["vendor/suite_test.go"] = "package vendor_test",
		})

		assert.is_false(adapter.filter_dir("vendor", "vendor", root))

		async.fn.delete(root, "rf")
	end)

	nio_tests.it("does not recurse into vendor subdirectories", function()
		local root = make_dir_tree({
			["internal/vendor/pkg/suite_test.go"] = "package pkg_test",
		})

		-- internal/ contains vendor/ which contains a suite file,
		-- but vendor should not be traversed
		assert.is_false(adapter.filter_dir("internal", "internal", root))

		async.fn.delete(root, "rf")
	end)
end)
