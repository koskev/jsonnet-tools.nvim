JsonnetDebugger = {}

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
			jpaths = function()
				return helper.get_config_merge(ls_name, "jpaths", jpaths)
			end
		},
	}
end

return JsonnetDebugger
