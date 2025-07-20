local M = {}

function M.setup()
	vim.api.nvim_create_user_command("JsonnetPreview", function()
		local preview = require("jsonnet-tools.jsonnet_preview")
		preview:toggle()
	end, {})
end

return M
