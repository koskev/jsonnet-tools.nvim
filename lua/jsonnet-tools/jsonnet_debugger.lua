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



function JsonnetDebugger:setup(binary, args, jpaths)
	local extcode = getExtcodeFromFiles();
	local dap = require("dap")
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
			extcode = extcode,
			-- TODO: get paths from lsp?
			jpaths = jpaths
		},
	}
end

return JsonnetDebugger
