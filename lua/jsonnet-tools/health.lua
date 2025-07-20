local M = {}
M.check = function()
	vim.health.start("foo report")
	-- make sure setup function parameters are ok
	vim.health.ok("Setup is correct")
	-- do some more checking
	-- ...
end
return M
