-- ownpack {{{
ownpack = vim.fn.stdpath('data') .. '/site/pack/ownpack/start'

p4_dir = ownpack .. '/p4.vim'
if vim.fn.isdirectory(p4_dir) == 0 then
	vim.api.nvim_command('!git clone https://github.com/oshiba03/p4.vim ' .. p4_dir)
end
-- }}}

-- Bootstrap lazy.nvim {{{
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- }}}

require('lazy').setup({
	spec = {
		{
			'nvim-lualine/lualine.nvim',
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			config = function()
				require('lualine').setup()
			end
		},
		{
			'nvim-treesitter/nvim-treesitter',
			build = ':TSUpdate',
			config = function()
				require('nvim-treesitter.configs').setup({
					ensure_installed = { 'c', 'cpp', 'lua', 'python' },
					highlight = { enable = true },
				})
			end
		},
		{
			'nvim-telescope/telescope.nvim',
			tag = '0.1.8',
			dependencies = {
				'nvim-lua/plenary.nvim',
				'BurntSushi/ripgrep',
				'nvim-treesitter/nvim-treesitter',
			},
			config = function()
				require('telescope').setup({
					defaults = {
						mappings = {
							n = {
								['q'] = require('telescope.actions').close,
								['t'] = require('telescope.actions').select_tab,
							},
							i = {
								['<C-j>'] = { '<esc>', type = 'command' },
								['<CR>'] = { '<esc>', type = 'command' },
							},
						},
					},
					pickers = {
						find_files = {
							layout_strategy = 'center',
							sorting_strategy = 'ascending',
							previewer = false,
						},
					},
					extensions = {
						file_browser = {
							initial_mode = 'normal',
							sorting_strategy = 'ascending',
							previewer = false,
						}
					},
				})

				vim.keymap.set('n',	'<C-p>', function() require('telescope.builtin').find_files(find_files_opts) end, { noremap = true })
				vim.keymap.set('n', '<Leader>o', require('telescope.builtin').treesitter, { noremap = true })
			end
		},
		{
			'nvim-telescope/telescope-file-browser.nvim',
			lazy = true,
			dependencies = {
				'nvim-telescope/telescope.nvim'
			},
			keys = {
				{ '<C-e>', function() require('telescope').extensions.file_browser.file_browser() end },
			},
			config = function()
				require('telescope').load_extension('file_browser')
			end
		},
		{
			'embear/vim-localvimrc',
			event = 'BufReadPre',
			init = function()
				vim.api.nvim_set_var('localvimrc_name', 'lvimrc.lua')
				vim.api.nvim_set_var('localvimrc_ask', 0)
				vim.api.nvim_set_var('localvimrc_sandbox', 0)
			end
		},
		{
			'phaazon/hop.nvim',
			config = function()
				require('hop').setup()
				vim.keymap.set('n', '<Leader>w', function() require('hop').hint_words() end, {noremap=true})
				vim.keymap.set('n', '<Leader>s', function() require('hop').hint_char2() end, {noremap=true})
				vim.keymap.set('n', '<Leader>l', function() require('hop').hint_lines() end, {noremap=true})
			end
		},
		{
			'junegunn/vim-easy-align',
			config = function()
				vim.keymap.set('v', '<Enter>', '<Plug>(EasyAlign)', {noremap=true})
				vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)', {noremap=true})
				easy_align_delimiters = {}
				easy_align_delimiters["]"] = {
					pattern = "]",
					left_margin = 0,
					right_margin = 1,
					stick_to_left = 0,
				}
				easy_align_delimiters[")"] = {
					pattern = ")",
					left_margin = 0,
					right_margin = 1,
					stick_to_left = 0,
				}
				vim.api.nvim_set_var('easy_align_delimiters', easy_align_delimiters)
				vim.keymap.set('v', '<Enter>', '<Plug>(EasyAlign)', {noremap=true})
			end
		},
		{
			'pepo-le/win-ime-con.nvim',
			lazy = true,
			event = 'InsertEnter',
			config = function()
				vim.api.nvim_set_var('win_ime_con_mode', 0)
			end
		},
		{
			'delphinus/cellwidths.nvim',
			config = function()
				require('cellwidths').setup()
			end
		},
		{
			'glidenote/memolist.vim',
			config = function()
				vim.api.nvim_set_var('memolist_path', vim.fn.stdpath('data') .. '/memo')
				vim.keymap.set('n', '<Leader>mn', '<cmd>MemoNew<CR>', {noremap=true})
				vim.keymap.set('n', '<Leader>ml', '<cmd>MemoList<CR>', {noremap=true})
				vim.keymap.set('n', '<Leader>mg', '<cmd>MemoGrep<CR>', {noremap=true})
			end
		},{
			'mileszs/ack.vim',
			init = function()
				vim.api.nvim_set_var('ackprg', 'rg')
			end
		},
		{
			'EdenEast/nightfox.nvim',
			dependencies = { 'nvim-telescope/telescope.nvim' },
			config = function()
				require('nightfox').setup({
					groups = {
						nightfox = {
							TabLineSel = { fg = '#cdcecf', bg = '#192330' },
							TabLine = { fg = '#192330', bg = '#71839b' },
							TelescopeBorder = { fg = 'white' },
						}
					}
				})

				vim.api.nvim_command('colorscheme nightfox')
			end
		},
		{
		},
		{ 'equalsraf/neovim-gui-shim' },
		{ 'ntpeters/vim-better-whitespace' },
		{ 'shortcuts/no-neck-pain.nvim' },
		{ 'oshiba03/p4.vim' },
	}
})

-- vim:set foldmethod=marker foldmarker={{{,--\ }}}:
