local severity_map = {
	["fatal"] = vim.diagnostic.severity.ERROR,
	["error"] = vim.diagnostic.severity.ERROR,
	["warning"] = vim.diagnostic.severity.WARN,
	["convention"] = vim.diagnostic.severity.HINT,
	["refactor"] = vim.diagnostic.severity.INFO,
	["info"] = vim.diagnostic.severity.INFO,
}

return {
	{ lazy = true, "nvim-lua/plenary.nvim" },

	{
		"EdenEast/nightfox.nvim",
		priority = 1000,
		config = true,
	},

	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		opts = {},
	},

	{
		"nvim-tree/nvim-web-devicons",
		opts = {},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("plugins.configs.treesitter")
		end,
	},

	{
		"akinsho/bufferline.nvim",
		event = "BufReadPre",
		opts = require("plugins.configs.bufferline"),
		dependencies = "nvim-tree/nvim-web-devicons",
		lazy = false,
	},

	{
		"echasnovski/mini.statusline",
		config = function()
			require("mini.statusline").setup({ set_vim_settings = false })
		end,
	},

	-- we use cmp plugin only when in insert mode
	-- so lets lazyload it at InsertEnter event, to know all the events check h-events
	-- completion , now all of these plugins are dependent on cmp, we load them after cmp
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- cmp sources
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",

			--list of default snippets
			"rafamadriz/friendly-snippets",

			-- snippets engine
			{
				"L3MON4D3/LuaSnip",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},

			-- autopairs , autocompletes ()[] etc
			{
				"windwp/nvim-autopairs",
				config = function()
					require("nvim-autopairs").setup()

					local cmp_autopairs = require("nvim-autopairs.completion.cmp")
					local cmp = require("cmp")
					cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
				end,
			},
		},
		-- made opts a function cuz cmp config calls cmp module
		-- and we lazyloaded cmp so we dont want that file to be read on startup!
		opts = function()
			return require("plugins.configs.cmp")
		end,
	},

	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = { "Mason", "MasonInstall" },
		opts = {},
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("plugins.configs.lspconfig")
		end,
	},

	{
		"stevearc/conform.nvim",
		lazy = true,
		opts = {
			formatters = {
				prettier = {
					command = "node_modules/prettier/bin/prettier.cjs",
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				scss = { "prettier" },
			},
		},
	},

	-- {
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	event = { "BufReadPre", "BufNewFile" },
	-- 	config = function()
	-- 		require("ibl").setup({
	-- 			indent = { char = "│" },
	-- 			scope = { char = "│", highlight = "Comment" },
	-- 		})
	-- 	end,
	-- },

	-- files finder etc
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-telescope/telescope-live-grep-args.nvim",
			version = "^1.0.0",
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = { prompt_position = "top" },
					},
					layout_strategy = "vertical",
					mappings = {
						i = {
							["<S-Down>"] = require("telescope.actions").cycle_history_next,
							["<S-Up>"] = require("telescope.actions").cycle_history_prev,
						},
					},
				},
			})
			telescope.load_extension("live_grep_args")
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gitsigns.nav_hunk("next")
						end
					end)

					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end)

					-- Actions
					map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git add hunk" })
					map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git reset hunk" })
					map("v", "<leader>hs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("v", "<leader>hr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git add file" })
					map("n", "<leader>hu", gitsigns.undo_stage_hunk)
					map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git reset file" })
					map("n", "<leader>hp", gitsigns.preview_hunk)
					map("n", "<leader>hb", function()
						gitsigns.blame_line({ full = true })
					end)
					map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
					map("n", "<leader>hd", gitsigns.diffthis)
					map("n", "<leader>hD", function()
						gitsigns.diffthis("~")
					end)
					map("n", "<leader>td", gitsigns.toggle_deleted)

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},

	-- persist sessions
	{
		"rmagatti/auto-session",
		lazy = false,
		opts = {
			suppressed_dirs = { "~/Downloads", "/" },
		},
	},

	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			-- "antoinemadec/FixCursorHold.nvim",
			-- adapters
			"olimorris/neotest-rspec",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-rspec")({
						rspec_cmd = function()
							return vim.tbl_flatten({ "bundle", "exec", "rspec" })
						end,
					}),
				},
			})
		end,
		keys = {
			{
				"<leader>t",
				"",
				desc = "+test",
			},
			{
				"<leader>tt",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run File",
			},
			{
				"<leader>tT",
				function()
					require("neotest").run.run(vim.uv.cwd())
				end,
				desc = "Run All Test Files",
			},
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest",
			},
			{
				"<leader>tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle Summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Show Output",
			},
			{
				"<leader>tO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle Output Panel",
			},
			{
				"<leader>tS",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop",
			},
			{
				"<leader>tw",
				function()
					require("neotest").watch.toggle(vim.fn.expand("%"))
				end,
				desc = "Toggle Watch",
			},
		},
	},

	-- shortcuts help tooltip that appears upon pressing a key with a short delay
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
	},

	{
		"slim-template/vim-slim", -- Syntax highlighting for VIM
	},

	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			require("mini.files").setup()
		end,
	},

	-- slim-lint
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters.slim_lint = {
				cmd = "bundle",
				stdin = false, -- Disable stdin since slim-lint works with files
				args = { "exec", "slim-lint", "--reporter", "json" },
				append_fname = true,
				stream = "stdout",
				ignore_exitcode = true, -- Slim-lint returns non-zero exit codes on lint errors, we can ignore those
				parser = function(output)
					local diagnostics = {}
					local decoded = vim.json.decode(output)

					if not decoded.files[1] then
						return diagnostics
					end

					local offences = decoded.files[1].offenses

					for _, off in pairs(offences) do
						local col =
							string.len(vim.api.nvim_buf_get_lines(0, off.location.line - 1, off.location.line, true)[1])
						table.insert(diagnostics, {
							source = "slim-lint",
							lnum = off.location.line - 1,
							end_lnum = off.location.line - 1,
							col = col + 1,
							end_col = col + 1,
							severity = severity_map[off.severity],
							message = off.message,
							code = off.linter,
						})
					end

					return diagnostics
				end,
			}
		end,
	},

	{
		"mg979/vim-visual-multi",
		init = function()
			vim.g.VM_maps = {
				["Add Cursor Down"] = "<C-S-j>",
				["Add Cursor Up"] = "<C-S-k>",
			}
		end,
	},

	-- markdown preview
	{
		"toppair/peek.nvim",
		event = { "VeryLazy" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup()
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},

	-- global search and replace
	{
		"MagicDuck/grug-far.nvim",
		config = function()
			require("grug-far").setup({})
		end,
		keys = {
			{
				"<leader>sr",
				function()
					local grug = require("grug-far")
					local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
					grug.open({
						transient = true,
						prefills = {
							filesFilter = ext and ext ~= "" and "*." .. ext or nil,
						},
					})
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
	},

	-- git plugin (:G blame)
	{
		"tpope/vim-fugitive",
	},

	-- GitHub extension for fugitive to make GBrowse work
	{
		"tpope/vim-rhubarb",
	},

	-- {
	--   "tpope/vim-rails",
	-- },

	{
		"victormours/ruby-memoize.vim",
	},

	-- syntax highlighting for jinja template language (11ty)
	{
		"lepture/vim-jinja",
	},

	-- fix :W typo
	-- disabled because it breaks GBrowse
	-- {
	-- 	"gcmt/cmdfix.nvim",
	-- 	config = function()
	-- 		require("cmdfix").setup({
	-- 			enabled = true,
	-- 			ignore = { "GBrowse" },
	-- 		})
	-- 	end,
	-- },

	-- gS and gJ to toggle between multi-line and single line method call
	{
		"AndrewRadev/splitjoin.vim",
	},

	-- close all buffers but current one
	{
		"ojroques/nvim-bufdel",
		config = function()
			require("bufdel").setup({
				quit = false,
			})
		end,
	},
	{
		"pwntester/octo.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup()
		end,
	},
}
