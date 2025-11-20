JsonnetDebugger = {}


local function getExtcodeFromFiles()
	local retVal = {}
	local foundFiles = vim.fs.find(function(name, path)
			return name:match('.*extcode.libsonnet$')
		end,
		{ path = vim.fn.getcwd(), upward = true, type = "file" })
	if foundFiles == nil then
		return nil
	end
	for _, foundFile in ipairs(foundFiles) do
		local filename = vim.fs.basename(foundFile)
		local f = io.open(foundFile, "r")
		if f then
			local content = f:read "*all"
			retVal[vim.fn.fnamemodify(filename, ":r:r")] = content
		end
	end
	return retVal
end



function JsonnetDebugger:setup(binary, args, jpaths, ls_name)
	local dap = require("dap")
	local helper = require("jsonnet-tools.client_helper")
	dap.adapters.jsonnet = {
		type = "executable",
		command = binary,
		args = args,
	}
	dap.configurations.jsonnet = {
		{
			type = "jsonnet",
			request = "launch",
			name = "Debug Jsonnet",

			program = "${file}",
			extcode = function()
				return helper.get_config_merge(ls_name, "extcode", {})
			end,
			extvars = function()
				return helper.get_config_merge(ls_name, "extvars", {})
			end,
			-- TODO: get paths from lsp?
			jpaths = function()
				return helper.get_config_merge(ls_name, "jpaths", jpaths)
			end
		},
	}
end

return JsonnetDebugger
