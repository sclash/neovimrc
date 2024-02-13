

-- references:
-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes

    require("neo-tree").setup({
      close_if_last_window = true,
      popup_border_style = "single",
      enable_git_status = true,
      enable_modified_markers = true,
      enable_diagnostics = true,
      sort_case_insensitive = true,
      default_component_configs = {
        indent = {
          with_markers = false,
          with_expanders = true,
        },
        modified = {
          symbol = " ",
          highlight = "NeoTreeModified",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          folder_empty_open = "",
        },
--	keys = {
--		{ "<leader><5>",     ":Neotree toggle float<CR>", silent = true, desc = "Float File Explorer" },
--		{ "<leader><tab>", ":Neotree toggle left<CR>",  silent = true, desc = "Left File Explorer" },
--	},
        git_status = {
          symbols = {
            -- Change type
            added = "",
            deleted = "",
            modified = "",
            renamed = "",
            -- Status type
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
      },
      window = {
        position = "float",
        width = 35,
	mappings = {

		["<space>"] = { 
			"toggle_node", 
			nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use 
		},
		["<2-LeftMouse>"] = "open",
		["<cr>"] = "open",
		["<esc>"] = "cancel", -- close preview or floating neo-tree window
		["P"] = { "toggle_preview", config = { use_float = true } },
		["l"] = "focus_preview",
		["S"] = "open_split",
		["s"] = "open_vsplit",
		-- ["S"] = "split_with_window_picker",
		-- ["s"] = "vsplit_with_window_picker",
		["t"] = "open_tabnew",
		-- ["<cr>"] = "open_drop",
		-- ["t"] = "open_tab_drop",
		["w"] = "open_with_window_picker",
		--["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
		["C"] = "close_node",
		-- ['C'] = 'close_all_subnodes',
		["z"] = "close_all_nodes",
		--["Z"] = "expand_all_nodes",
		["a"] = { 
			"add",
			-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
			-- some commands may take optional config options, see `:h neo-tree-mappings` for details
			config = {
				show_path = "none" -- "none", "relative", "absolute"
			}
		},
		["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
		["d"] = "delete",
		["r"] = "rename",
		["y"] = "copy_to_clipboard",
		["x"] = "cut_to_clipboard",
		["p"] = "paste_from_clipboard",
		["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
		-- ["c"] = {
			--  "copy",
			--  config = {
				--    show_path = "none" -- "none", "relative", "absolute"
				--  }
				--}
				["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
				["q"] = "close_window",
				["R"] = "refresh",
				["?"] = "show_help",
				["<"] = "prev_source",
				[">"] = "next_source",
			},
		},
      filesystem = {
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
      },
      event_handlers = {
        -- {
        --     event = "file_opened",
        --     handler = function()
        --         --auto close
        --         require("neo-tree").close_all()
        --     end,
        -- },
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
      },
    })
