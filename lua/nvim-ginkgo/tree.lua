-- TreeSitter-based test tree parsing for Ginkgo v2
-- Wraps neotest.lib.treesitter.parse_positions with Ginkgo-specific logic

local M = {}

-- Query cache to avoid repeated file reads
local query_cache = {}

-- When variants that Ginkgo implements as Describe with a "when " prefix.
-- When("text") compiles to Describe("when text") internally, so the captured
-- name must include the "when " prefix to match Ginkgo's JSON report output.
local WHEN_VARIANTS = { "When", "FWhen", "PWhen", "XWhen" }

-- Post-process the parsed tree to fix When node names and propagate corrected
-- IDs down to all descendant nodes.
local function fix_when_names(tree, lines)
	local function fix_subtree(node, parent_id)
		local data = node:data()
		local my_id = parent_id .. "::" .. data.name
		data.id = my_id

		if data.type == "namespace" then
			local line = lines[data.range[1] + 1] or ""
			for _, variant in ipairs(WHEN_VARIANTS) do
				if line:match("^%s*" .. variant .. "%s*%(") then
					local inner = data.name:sub(2, -2)
					data.name = '"when ' .. inner .. '"'
					my_id = parent_id .. "::" .. data.name
					data.id = my_id
					break
				end
			end
		end

		for _, child in ipairs(node:children()) do
			fix_subtree(child, my_id)
		end
	end

	local root = tree:data()
	for _, child in ipairs(tree:children()) do
		fix_subtree(child, root.id)
	end
end

-- Get the plugin root directory
local function get_plugin_root()
	local source = debug.getinfo(1, "S").source:sub(2)
	return vim.fn.fnamemodify(source, ":p:h:h:h")
end

-- Load a query file by name
-- @param name string Query name (namespace, test, lifecycle, entry)
-- @return string Query content
local function load_query(name)
	if query_cache[name] then
		return query_cache[name]
	end

	local plugin_root = get_plugin_root()
	local query_path = plugin_root .. "/lua/nvim-ginkgo/queries/ginkgo/" .. name .. ".scm"

	local file = io.open(query_path, "r")
	if not file then
		error("Could not open query file: " .. query_path)
	end

	local content = file:read("*all")
	file:close()

	query_cache[name] = content
	return content
end

-- Parse test positions from a Go test file
-- @param path string Absolute path to Go test file
-- @return neotest.Tree|nil Tree of positions or nil on error
--
-- Entry Node Support:
-- Entry nodes in DescribeTable are now detected as test nodes (like It).
-- They are included in the test.scm query and automatically detected by neotest.lib.
function M.parse_positions(path)
	-- Load and combine queries (namespace + test, including Entry as tests)
	local namespace_query = load_query("namespace")
	local test_query = load_query("test")
	local combined_query = namespace_query .. "\n" .. test_query

	-- Parse using neotest lib to get all nodes including Entry as tests
	local lib = require("neotest.lib")
	local opts = {
		nested_namespaces = true,
		require_namespaces = true,
	}

	-- Wrap in pcall to handle file read errors gracefully
	local ok, tree = pcall(lib.treesitter.parse_positions, path, combined_query, opts)
	if not ok then
		return nil
	end

	-- Fix When node names: When("text") is Describe("when text") in Ginkgo,
	-- so we prepend "when " to match what the JSON report will contain.
	local lines = {}
	local file = io.open(path, "r")
	if file then
		for line in file:lines() do
			table.insert(lines, line)
		end
		file:close()
		fix_when_names(tree, lines)
	end

	return tree
end

return M
