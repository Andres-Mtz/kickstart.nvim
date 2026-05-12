-- lazyload.lua
-- Queues plugin setup behind the VimEnter event for snappy startup.
-- Based on: https://fredrikaverpil.github.io/blog/2026/04/15/from-lazy.nvim-to-vim.pack/
--
-- Usage (in plugin/*.lua files):
--   require("lazyload").on_vim_enter(function()
--     vim.pack.add(...)
--     require("plugin").setup(...)
--   end)

local M = {}

local vim_enter_queue = {}
local override_queue = {}

local function drain(queue)
	-- First pass: schedule async callbacks
	for _, entry in ipairs(queue) do
		if not entry.sync then
			vim.schedule(entry.fn)
		end
	end
	-- Second pass: run synchronous callbacks inline
	for _, entry in ipairs(queue) do
		if entry.sync then
			entry.fn()
		end
	end
end

local function drain_override()
	if not override_queue then
		return
	end
	for _, entry in ipairs(override_queue) do
		vim.schedule(function()
			local ok, err = pcall(entry.fn)
			if not ok then
				vim.notify((".nvim.lua override error:\n%s"):format(err), vim.log.levels.ERROR)
			end
		end)
	end
	override_queue = nil
end

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		drain(vim_enter_queue)
		vim_enter_queue = nil
		drain_override()
	end,
})

--- Queue a function to run on VimEnter.
--- If VimEnter has already fired, runs immediately (or via vim.schedule for async).
---@param fn function
---@param opts? { sync: boolean }
function M.on_vim_enter(fn, opts)
	local sync = opts and opts.sync or false
	if vim_enter_queue then
		table.insert(vim_enter_queue, { fn = fn, sync = sync })
	elseif sync then
		fn()
	else
		vim.schedule(fn)
	end
end

--- Queue a function to run AFTER all VimEnter callbacks (for per-project overrides).
---@param fn function
function M.on_override(fn)
	if override_queue then
		table.insert(override_queue, { fn = fn })
	else
		vim.schedule(fn)
	end
end

return M
