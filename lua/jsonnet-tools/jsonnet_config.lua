--TODO: split up file config and nvim config
---@class JsonnetConfig
---@field language_server_name string
JsonnetConfig = {
	language_server_name = "grustonnet_ls",

	debugger = {
		enabled = true,
		binary = "jsonnet-debugger",
		debugger_args = { "--dap", "-s" },
		jpaths = {}
	}

}

return JsonnetConfig
