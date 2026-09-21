local lsp = { "lua_ls" }
local dir = vim.fn.stdpath("config") .. "/lsp"
local url = "https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/lsp"

vim.fn.mkdir(dir, "p")
for _, n in ipairs(lsp) do
	local f = dir .. "/" .. n .. ".lua"
	if vim.fn.filereadable(f) == 0 then
		vim.system({ "curl", "-fsSL", "-o", f, url .. "/" .. n .. ".lua" })
	end
end
vim.lsp.enable(lsp)
