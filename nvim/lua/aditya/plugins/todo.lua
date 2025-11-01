return {
	"folke/todo-comments.nvim",
	lazy = false,
	config = function()
		-- TODO: This is a todo message.
		-- HACK: This is a hack.
		-- FIXME: This should really be fixed.
		-- FIX:
		-- BUG:
		-- ISSUE:
		-- NOTE: This is just a note.
		-- INFO:
		-- LEFTOFF: This is where I left off.
		-- PERF: Performance improvements.
		-- OPTIM:
		-- OPTIMIZE:
		-- PERFORMANCE:
		-- WARNING:
		-- WARN:
		-- XXX:
		-- TEST:
		-- TESTING:
		-- PASSED:
		-- FAILED:

		-- TODO(aditya): This is a aditya-specific todo.

		require("todo-comments").setup({
			keywords = {
				TODO = { color = "#F85552" },
				HACK = { color = "#F57D26" },
				NOTE = { color = "#8DA101" },
				FIX = { color = "#3A94C5" },
				LEFTOFF = { color = "#F0F2D4" },
			},
			highlight = {
				multiline = false,
				pattern = [[(KEYWORDS)\s*(\([^\)]*\))?:]],
				keyword = "wide_fg",
				after = "",
			},
		})
	end,
}
