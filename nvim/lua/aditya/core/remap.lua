vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.zig_fmt_autosave = 1
vim.g.zig_fmt_parse_errors = 0
vim.g.have_nerd_font = true

vim.diagnostic.config({ virtual_text = true })

vim.keymap.set("", "<leader>l", function()
	local config = vim.diagnostic.config() or {}
	if config.virtual_text then
		vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
	else
		vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
	end
end, { desc = "Toggle lsp_lines" })

vim.opt.guifont = "Berkeley Mono"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.undofile = true
vim.opt.signcolumn = "yes"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.wrap = false
vim.opt.swapfile = false

vim.opt.scrolloff = 12
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.api.nvim_create_user_command("W", "w", {})

-- Expand a split and bring it back
vim.keymap.set("n", "<leader>=", "<C-w>=")
vim.keymap.set("n", "<leader>\\", "<C-w>|")
vim.opt.backup = false
vim.opt.swapfile = false
-- vim.opt.undodir = os.getenv("HOMEPATH") .. "/.nvim/undodir"
vim.opt.undofile = true

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- This will put the word currently under the cursor to replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- greatest remap ever
vim.keymap.set("n", "<leader>pp", [["+p]])
vim.keymap.set("n", "<leader>P", [["+P]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_prev() })
end)
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ diagnostic = vim.diagnostic.get_next() })
end)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
--
---- Use LspAttach autocommand to only map the following keys
---- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("AdityaLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "gD", builtin.lsp_definitions, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>gi", builtin.lsp_implementations, opts)
		vim.keymap.set("n", "<leader>D", builtin.lsp_type_definitions, opts)
		vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, opts)
		vim.keymap.set("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, opts)
		vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, opts)

		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)

		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>gr", builtin.lsp_references, opts)
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client == nil then
			return
		end
		if client.name == "ruff" then
			-- Disable hover in favor of Pyright
			client.server_capabilities.hoverProvider = false
		end
	end,
	desc = "LSP: Disable hover capability from Ruff",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("aditya-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
