local M = {}

---@param opts JsonnetConfig
function M.setup(opts)
	local default_config = require("jsonnet-tools.jsonnet_config")
	local config = vim.tbl_deep_extend("force", default_config, opts or {})

	vim.api.nvim_create_user_command("JsonnetPreview", function()
		local preview = require("jsonnet-tools.jsonnet_preview")
		preview:toggle(config.language_server_name)
	end, {})
	if config.debugger.enabled then
		local debugger = require("jsonnet-tools.jsonnet_debugger")
		debugger:setup(config.debugger.binary, config.debugger.debugger_args, config.debugger.jpaths,
			config.language_server_name)
	end
end

return M
