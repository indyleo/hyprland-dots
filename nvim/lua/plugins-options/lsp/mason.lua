-- Mason
local servers_lsp = {
  "lua_ls",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "marksman",
  "vimls",
  "taplo",
  "ltex",
  "clangd",
  "cmake",
  "html",
  "htmx",
}

local servers_dap = {
  "bash",
  "python",
  "codelldb",
  "js-debug-adapter",
}

local servers_null_ls = {
  "shellcheck",
  "yamllint",
  "flake8",
  "jsonlint",
  "vint",
  "markdownlint",
  "luacheck",
  "cpplint",
  "htmlhint",

  "autoflake",
  "beautysh",
  "cbfmt",
  "jq",
  "stylua",
  "textlint",
  "clang-format",
  "cmakelang",
}

local settings = {
	ui = {
		border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

require("mason").setup(settings)

require("mason-lspconfig").setup({
	ensure_installed = servers_lsp,
	automatic_installation = true,
})

require("mason-nvim-dap").setup({
  ensure_installed = servers_dap,
	automatic_installation = true,
})

require("mason-null-ls").setup({
  ensure_installed = servers_null_ls,
	automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

for _, server in pairs(servers_lsp) do
	opts = {
		on_attach = require("plugins-options.lsp.handlers").on_attach,
		capabilities = require("plugins-options.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "plugins-options.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
