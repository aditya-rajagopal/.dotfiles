return {
	"theprimeagen/harpoon",
	branch = "harpoon2",
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		-- local mark = require("harpoon.mark")
		-- local ui = require("harpoon.ui")
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		vim.keymap.set("n", "<S-h>", function()
			harpoon:list():prev({ ui_nav_wrap = true })
		end)
		vim.keymap.set("n", "<S-l>", function()
			harpoon:list():next({ ui_nav_wrap = true })
		end)

		for _, idx in ipairs({ 1, 2, 3, 4, 5 }) do
			vim.keymap.set("n", string.format("<leader>%d", idx), function()
				harpoon:list():select(idx)
			end)
		end
	end,
}
