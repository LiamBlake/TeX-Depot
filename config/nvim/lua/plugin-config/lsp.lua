local M = {}

M.install_servers = function()
	for lang in { "cmake", "cpp", "html", "latex", "lua", "python", "typescript", "julials" } do
		require("lspinstall").install_server(lang)
	end
end

-- Only show diagnostics detail on hover
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
-- 	virtual_text = false,
-- 	underline = true,
-- 	signs = true,
-- })
-- vim.cmd([[
-- 	autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
-- 	autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
-- ]])

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client)
	-- Format on save
	if client.resolved_capabilities.document_formatting then
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)")
	end
end

-- Set up language servers
M.setup_servers = function()
	require("lspinstall").setup()
	local servers = require("lspinstall").installed_servers()
	for _, server in pairs(servers) do
		require("lspconfig")[server].setup({ capabilities = capabilities, on_attach = on_attach })
	end

	-- Additional language servers not supported by lsp-install
	-- Note: Formatting of Julia is handled by a Vim command, so the custom on_attach is not needed.
	require("lspconfig").julials.setup({})

	-- null-ls
	require("lspconfig")["null-ls"].setup({ capabilities = capabilities, on_attach = on_attach })
end

-- Symbols
M.lspkind_setup = function()
	require("lspkind").init({
		with_text = false,
		preset = "codicons",
		symbol_map = {
			Text = "",
			Method = "",
			Function = "",
			Constructor = "",
			Field = "ﰠ",
			Variable = "",
			Class = "ﴯ",
			Interface = "",
			Module = "",
			Property = "ﰠ",
			Unit = "塞",
			Value = "",
			Enum = "",
			Keyword = "",
			Snippet = "",
			Color = "",
			File = "",
			Reference = "",
			Folder = "",
			EnumMember = "",
			Constant = "",
			Struct = "פּ",
			Event = "",
			Operator = "",
			TypeParameter = "",
		},
	})
end
-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require("lspinstall").post_install_hook = function()
	setup_servers() -- reload installed servers
	vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

return M
