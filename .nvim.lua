local lsp = {
}

local dir = vim.fn.getcwd() .. "/lsp"
local url = "https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/lsp"

vim.fn.mkdir(dir, "p")

for _, n in ipairs(lsp) do
	local f = dir .. "/" .. n .. ".lua"
	if vim.fn.filereadable(f) == 0 then
		vim.system({ "curl", "-fsSL", "-o", f, url .. "/" .. n .. ".lua" }):wait()
	end
end

vim.opt.rtp:prepend(vim.fn.getcwd())
vim.lsp.enable(lsp)
