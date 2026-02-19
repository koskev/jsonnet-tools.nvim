local M = {}

function M.get_client(ls_name)
	local clients = vim.lsp.get_clients({ name = ls_name })
	if #clients == 0 then
		return nil
	end
	return clients[1]
end

function M.get_config(client, name)
	local params = {
		command = "config." .. name,
		arguments = {},
	}
	local val, err = client:request_sync("workspace/executeCommand", params)
	if err then
		vim.notify("Unable to get " .. name .. " got error " .. tostring(err), vim.log.levels.WARN)
		return nil
	end
	return val.result
end

function M.get_config_merge(ls_name, name, orig_val)
	local client = M.get_client(ls_name)
	if client == nil then
		vim.notify("Could not get client for " .. ls_name, vim.log.levels.WARN)
		return orig_val
	end
	local res = M.get_config(client, name)

	return vim.tbl_deep_extend("force", orig_val, res or {})
end

return M
