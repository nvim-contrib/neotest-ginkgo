local lib = require("neotest.lib")
local async = require("neotest.async")
local logger = require("neotest.logging")
local output = require("neotest-ginkgo.output")

local M = {}

---Create a unique location identifier for a test spec
---@param spec table The spec item from Ginkgo report
---@return string Unique identifier in format "file.go::\"Describe\"::\"Context\"::\"It\""
local function create_location_id(spec)
	local segments = {}
	-- add the spec filename
	table.insert(segments, spec.LeafNodeLocation.FileName)
	-- add the spec hierarchy
	for _, segment in pairs(spec.ContainerHierarchyTexts) do
		table.insert(segments, '"' .. segment .. '"')
	end
	-- add the spec text
	table.insert(segments, '"' .. spec.LeafNodeText .. '"')

	local id = table.concat(segments, "::")
	-- done
	return id
end

---Build a namespace ID from file path and hierarchy segments
---@param file_path string The file path
---@param hierarchy_segments table Array of hierarchy segment strings
---@return string Namespace identifier in format "file.go::\"Describe\"::\"Context\""
local function build_namespace_id(file_path, hierarchy_segments)
	local segments = { file_path }
	for _, segment in ipairs(hierarchy_segments) do
		table.insert(segments, '"' .. segment .. '"')
	end
	return table.concat(segments, "::")
end

---Aggregate status from child test results
---@param children table Array of child info with status field
---@return string Status: "failed", "passed", or "skipped"
local function aggregate_status(children)
	local has_failed = false
	local has_passed = false

	for _, child in ipairs(children) do
		if child.status == "failed" then
			has_failed = true
		elseif child.status == "passed" then
			has_passed = true
		end
	end

	if has_failed then
		return "failed"
	end
	if has_passed then
		return "passed"
	end
	return "skipped"
end

---Create an error object from a failed spec
---@param spec table The spec item from Ginkgo report
---@return table Error object with line number and message
local function create_error(spec)
	local failure = spec.Failure

	local err = {
		line = failure.FailureNodeLocation.LineNumber - 1,
		message = failure.Message,
	}

	if failure.Location.FileName == failure.FailureNodeLocation.FileName then
		err.line = failure.Location.LineNumber - 1
	end

	return err
end

---Parse Ginkgo test results from JSON report
---@async
---@param spec neotest.RunSpec
---@param result neotest.StrategyResult
---@param tree neotest.Tree
---@return table<string, neotest.Result>
---Collect suite data from all report files in the output directory.
---For single-suite runs ginkgo writes report.json directly.
---For multi-suite runs (./...) ginkgo prefixes each file with the suite
---name: integration_report.json, pg_report.json, etc.
---@param report_path string Expected path of the primary report file
---@param report_dir string Directory containing the report files
---@return table[] Combined array of suite items, empty on failure
local function collect_reports(report_path, report_dir)
	local report_name = vim.fn.fnamemodify(report_path, ":t")
	local suites = {}

	-- Single-suite run: exact filename exists
	local ok, data = pcall(lib.files.read, report_path)
	if ok then
		local dok, parsed = pcall(vim.json.decode, data, { luanil = { object = true } })
		if dok then
			vim.list_extend(suites, parsed)
		end
		return suites
	end

	-- Multi-suite run: {suite}_{report_name} files
	for _, file in ipairs(vim.fn.glob(report_dir .. "/*_" .. report_name, false, true)) do
		local fok, fdata = pcall(lib.files.read, file)
		if fok then
			local dok, parsed = pcall(vim.json.decode, fdata, { luanil = { object = true } })
			if dok then
				vim.list_extend(suites, parsed)
			end
		end
	end

	return suites
end

function M.parse(spec, result, tree)
	local collection = {}
	local report_path = spec.context.report_output_path
	local report_dir = vim.fn.fnamemodify(report_path, ":h")

	local report = collect_reports(report_path, report_dir)
	if #report == 0 then
		logger.error("No test output file found ", report_path)
		return {}
	end

	-- Track namespace data: namespace_id -> {children = {{status, short, errors}...}}
	local namespaces = {}

	for _, suite_item in pairs(report) do
		if suite_item.SpecReports == nil then
			local suite_item_node = {}
			if suite_item.SuiteSucceeded then
				suite_item_node.status = "passed"
			else
				suite_item_node.status = "failed"
			end

			local suite_item_node_id = suite_item.SuitePath
			collection[suite_item_node_id] = suite_item_node
		end

		-- Phase 1: Process leaf tests and track namespace data
		for _, spec_item in pairs(suite_item.SpecReports or {}) do
			if spec_item.LeafNodeType == "It" or spec_item.LeafNodeType == "Entry" then
				local spec_item_node = {}
				-- set the node short attribute
				spec_item_node.short = "[" .. string.upper(spec_item.State) .. "]"
				spec_item_node.short = spec_item_node.short .. " " .. output.create_spec_description(spec_item)
				-- set the node location
				spec_item_node.location = spec_item.LeafNodeLocation.LineNumber

				if spec_item.State == "pending" then
					spec_item_node.status = "skipped"
				elseif spec_item.State == "panicked" then
					spec_item_node.status = "failed"
				else
					spec_item_node.status = spec_item.State
				end

				local report_file = vim.fn.fnamemodify(async.fn.tempname(), ":t")
				-- set the node errors
				if spec_item.Failure ~= nil then
					spec_item_node.errors = {}

					local err = create_error(spec_item)
					-- add the error
					table.insert(spec_item_node.errors, err)
					-- prepare the output
					local err_output = output.create_error_output(spec_item)
					-- set the node output
					spec_item_node.output = report_dir .. "/" .. report_file
					-- write the output
					lib.files.write(spec_item_node.output, err_output)
					-- set the node short attribute
					spec_item_node.short = spec_item_node.short .. ": " .. err.message
				else
					-- set default output if no output captured
					if spec_item.CapturedGinkgoWriterOutput == nil then
						spec_item.CapturedGinkgoWriterOutput = ""
					end
					-- prepare the output
					local spec_output = output.create_spec_output(spec_item)
					-- set the node output
					spec_item_node.output = report_dir .. "/" .. report_file
					-- write the output
					lib.files.write(spec_item_node.output, spec_output)
				end

				local spec_item_node_id = create_location_id(spec_item)
				-- set the node
				collection[spec_item_node_id] = spec_item_node

				-- Track this test in all ancestor namespaces
				local file_path = spec_item.LeafNodeLocation.FileName
				local child_info = {
					status = spec_item_node.status,
					short = spec_item_node.short,
					errors = spec_item_node.errors,
				}

				-- Build namespace hierarchy from ContainerHierarchyTexts
				for level = 1, #spec_item.ContainerHierarchyTexts do
					local hierarchy_segments = {}
					for i = 1, level do
						table.insert(hierarchy_segments, spec_item.ContainerHierarchyTexts[i])
					end

					local namespace_id = build_namespace_id(file_path, hierarchy_segments)

					-- Initialize namespace if not exists
					if namespaces[namespace_id] == nil then
						report_file = vim.fn.fnamemodify(async.fn.tempname(), ":t")
						namespaces[namespace_id] = {
							children = {},
							output = report_dir .. "/" .. report_file,
						}
					end

					-- Add child info to this namespace
					table.insert(namespaces[namespace_id].children, child_info)
				end
			end
		end
	end

	-- Phase 2: Generate namespace results with aggregated status and output
	for namespace_id, data in pairs(namespaces) do
		local status = aggregate_status(data.children)

		-- Create summary output from child info
		local output_content = output.create_namespace_summary(data.children)
		lib.files.write(data.output, output_content)

		collection[namespace_id] = {
			status = status,
			output = data.output,
		}
	end

	return collection
end

return M
