JsonnetPreview = {
	group_id = nil,
	client = nil,
	preview_window = {
		win = 0,
		buf = 0,
	},
	edit_window = {
		buf = 0,
		win = 0,
	}
}


function JsonnetPreview:update()
	local function handler(err, res)
		if err == nil then
			vim.api.nvim_buf_set_lines(self.preview_window.buf, 0, -1, false, vim.split(res, '\n'))
		else
			vim.api.nvim_buf_set_lines(self.preview_window.buf, 0, -1, false, vim.split(err.message, '\n'))
		end
	end
	local client = self.client
	if client ~= nil then
		client:exec_cmd(
			{ title = "Evaluate file", command = "jsonnet.evalFile", arguments = { vim.fn.expand('%:p') } },
			{ bufnr = self.edit_window.buf },
			handler)
	end
end

function JsonnetPreview:unload()
	vim.notify("Unloading Jsonnet preview!")
	if self.group_id ~= nil then
		vim.api.nvim_del_augroup_by_id(self.group_id)
	end
	vim.api.nvim_win_close(self.preview_window.win, false)
	self.group_id = nil
end

function JsonnetPreview:setup_buffer_events()
	local group = vim.api.nvim_create_augroup("PreviewGroup", { clear = true })
	self.group_id = group
	-- Only directly react to changes in non insert mode
	vim.api.nvim_create_autocmd({ "TextChanged" }, {
		group = group,
		buffer = self.edit_window.buf,
		callback = function()
			self:update()
		end,
	})

	vim.api.nvim_create_autocmd("InsertLeave", {
		group = group,
		buffer = self.edit_window.buf,
		callback = function()
			self:update()
		end,
	})

	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		group = group,
		callback = function(args)
			local win = vim.api.nvim_get_current_win()
			if win == self.edit_window.win then
				self.edit_window.buf = args.buf
				self:update()
			end
		end,
	})

	vim.api.nvim_create_autocmd({ "WinClosed" }, {
		group = group,
		callback = function(args)
			local closed_window = tonumber(args.match)
			if closed_window == self.edit_window.win or closed_window == self.preview_window.win then
				self:unload()
			end
		end,
	})
end

function JsonnetPreview:toggle(ls_name)
	if self.group_id == nil then
		local clients = vim.lsp.get_clients({ name = ls_name })
		-- TODO: error handling
		self.client = clients[1]
		self.edit_window.buf = vim.api.nvim_get_current_buf()
		self.edit_window.win = vim.api.nvim_get_current_win()
		vim.cmd('set splitright')
		vim.cmd('vsplit')
		self.preview_window.win = vim.api.nvim_get_current_win()
		self.preview_window.buf = vim.api.nvim_create_buf(true, true)
		vim.api.nvim_win_set_buf(self.preview_window.win, self.preview_window.buf)
		vim.cmd('set filetype=json')
		-- Make the original window active again
		self:setup_buffer_events()
		vim.api.nvim_set_current_win(self.edit_window.win)
		self:update()
	else
		self:unload()
	end
end

return JsonnetPreview
