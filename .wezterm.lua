local wezterm = require("wezterm")

local sessionizer = wezterm.plugin.require("https://github.com/mikkasendke/sessionizer.wezterm")
local history = wezterm.plugin.require("https://github.com/mikkasendke/sessionizer-history")

local fd = "C:\\ProgramData\\chocolatey\\bin\\fd.exe"

local fd_search = function(folder)
	return function()
		local projects = {}

		-- run fd on all files in F:/
		local success, stdout, stderr = wezterm.run_child_process({
			fd,
			"-Hs",
			"^.git$",
			"-td",
			"--max-depth=4",
			"--prune",
			folder,
		})

		if not success then
			wezterm.log_error("Failed to run fd: " .. stderr)
		end

		for line in stdout:gmatch("[^\n]+") do
			line = line:gsub("\\", "/")
			local project = line:gsub("/.git.*$", "")
			table.insert(projects, { id = tostring(project), label = tostring(project) })
		end

		return projects
	end
end

local schema = {
	options = {
		prompt = "Workspace to switch: ",
		callback = history.Wrapper(sessionizer.DefaultCallback),
	},
	{
		sessionizer.AllActiveWorkspaces({ filter_current = false, filter_default = false }),
		processing = sessionizer.for_each_entry(function(entry)
			entry.label = wezterm.format({
				{ Text = "󱂬 : " .. entry.label },
			})
		end),
	},
	{ label = "nvim", id = "C:/Users/adira/AppData/Local/nvim" },
	sessionizer.DefaultWorkspace({}),
	history.MostRecentWorkspace({}),
	fd_search("F:/"),
	fd_search("C:/dev/"),
}

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end
config.font_dirs = { "fonts" }

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1500 }
config.keys = {}
config.enable_kitty_keyboard = true

table.insert(config.keys, {
	key = "f",
	mods = "LEADER|CTRL",
	action = sessionizer.show(schema),
})
table.insert(config.keys, {
	key = "m",
	mods = "LEADER|CTRL",
	action = history.switch_to_most_recent_workspace,
})
table.insert(config.keys, {
	key = "Enter",
	mods = "CTRL",
	action = wezterm.action.SendKey({ key = "Enter", mods = "CTRL" }),
})
table.insert(config.keys, {
	key = "Enter",
	mods = "CTRL|SHIFT",
	action = wezterm.action.SendKey({ key = "Enter", mods = "CTRL|SHIFT" }),
})

config.font = wezterm.font("Berkeley Mono", { weight = "Regular", stretch = "Normal", style = "Normal" }) -- C:\USERS\ADIRA\APPDATA\LOCAL\MICROSOFT\WINDOWS\FONTS\BERKELEYMONOVARIABLE-REGULAR.TTF index=0 variation=1, DirectWrite
config.font_size = 20
config.initial_cols = 128
config.initial_rows = 38

config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "home"
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
-- config.hide_tab_bar_if_only_one_tab = true
config.default_cwd = "F:/"
config.max_fps = 174
config.tab_bar_at_bottom = true
config.default_prog = { "pwsh.exe", "-NoLogo" }

local mux = wezterm.mux

wezterm.on("gui-startup", function()
	local _, _, window = mux.spawn_window({})
	window:gui_window():set_position(700, 20)
end)

wezterm.on("update-right-status", function(window, pane)
	-- Workspace name
	local stat = window:active_workspace()
	-- It's a little silly to have workspace name all the time
	-- Utilize this to display LDR or current key table name
	if window:active_key_table() then
		stat = window:active_key_table()
	end
	if window:leader_is_active() then
		stat = "LDR"
	end

	-- Current working directory
	local basename = function(s)
		-- Nothign a little regex can't fix
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end
	local cwd = pane:get_current_working_dir().file_path
	-- Current command
	local cmd = basename(pane:get_foreground_process_name())

	-- Time
	local time = wezterm.strftime("%H:%M:%S")

	-- Let's add color to one of the components
	window:set_right_status(wezterm.format({
		-- Wezterm has a built-in nerd fonts
		{ Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		{ Text = " | " },
		{ Foreground = { Color = "FFB86C" } },
		{ Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
		"ResetAttributes",
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
		{ Text = " |" },
	}))
end)

return config
