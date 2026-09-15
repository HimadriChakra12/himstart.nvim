local M = {}

M.opts = {
	cmd = "smd",                       -- the binary, change if it's not on PATH
	filetypes = { "markdown", "html" }, -- :MarkPreview refuses anything else
}

-- path -> job id, so hitting the keybind twice doesn't spawn two windows
local jobs = {}

local function running(path)
	local job = jobs[path]
	if not job then
		return false
	end
	-- jobwait with a 0 timeout just polls; -1 means "still running"
	return vim.fn.jobwait({ job }, 0)[1] == -1
end

function M.open(path)
	path = path or vim.api.nvim_buf_get_name(0)
	if path == "" then
		vim.notify("markpreview: buffer isn't a file yet", vim.log.levels.WARN)
		return
	end

	local ft = vim.bo.filetype
	if not vim.tbl_contains(M.opts.filetypes, ft) then
		vim.notify("markpreview: not a markdown/html buffer (filetype=" .. ft .. ")", vim.log.levels.WARN)
		return
	end

	if running(path) then
		return -- already open, nothing to do - smd's own watch handles updates
	end

	local job = vim.fn.jobstart(
		{ "sh", "-c", string.format("exec %s %s </dev/null >/dev/null 2>&1", M.opts.cmd, vim.fn.shellescape(path)) },
		{
			detach = true, -- survives :qa, doesn't tie its life to this nvim instance
			on_exit = function()
				jobs[path] = nil
			end,
		}
	)

	if job <= 0 then
		vim.notify("markpreview: couldn't start '" .. M.opts.cmd .. "'", vim.log.levels.ERROR)
		return
	end
	jobs[path] = job
end

function M.close(path)
	path = path or vim.api.nvim_buf_get_name(0)
	local job = jobs[path]
	if job then
		vim.fn.jobstop(job)
		jobs[path] = nil
	end
end

function M.setup(opts)
	M.opts = vim.tbl_extend("force", M.opts, opts or {})
end

vim.api.nvim_create_user_command("MarkPreview", function()
	M.open()
end, {})

vim.api.nvim_create_user_command("MarkPreviewClose", function()
	M.close()
end, {})

return M
