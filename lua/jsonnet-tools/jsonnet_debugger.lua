JsonnetDebugger = {}

function JsonnetDebugger:setup(binary, args, jpaths, extcode, extvars, ls_name)
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
				return helper.get_config_merge(ls_name, "extcode", extcode)
			end,
			extvars = function()
				return helper.get_config_merge(ls_name, "extvars", extvars)
			end,
			jpaths = function()
				return helper.get_config_merge(ls_name, "jpaths", jpaths)
			end
		},
	}
end

return JsonnetDebugger
