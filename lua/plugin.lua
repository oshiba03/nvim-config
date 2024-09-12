ownpack = vim.fn.stdpath('data') .. '/site/pack/ownpack/start'

molokai_dir = ownpack .. '/vim-molokaifork'
if vim.fn.isdirectory(molokai_dir) == 0 then
	vim.api.nvim_command('!git clone https://github.com/oshiba03/vim-molokaifork ' .. molokai_dir)
end

p4_dir = ownpack .. '/p4.vim'
if vim.fn.isdirectory(p4_dir) == 0 then
	vim.api.nvim_command('!git clone https://github.com/oshiba03/p4.vim ' .. p4_dir)
end

dein_dir = vim.fn.stdpath('data') .. '/dein'
dein_repo_dir = dein_dir .. '/repos/github.com/Shougo/dein.vim'
if vim.fn.isdirectory(dein_dir) == 0 then
	vim.api.nvim_command('!git clone --depth 1 https://github.com/Shougo/dein.vim ' .. dein_repo_dir)
end

vim.o.runtimepath = vim.o.runtimepath .. ',' .. dein_repo_dir
vim.api.nvim_create_autocmd(
	'VimEnter',
	{
		pattern = '*',
		callback = function() vim.fn['dein#call_hook']('post_source') end
	})

dein_hook_func = {}
dein_hook_types = {'hook_add', 'hook_post_source'}
function DeinAdd(name, config)
	if not config then
		vim.fn['dein#add'](name)
		return
	end

	for i, hook_type in ipairs(dein_hook_types) do
		if config[hook_type] then
			func_name = name .. '_' .. hook_type
			dein_hook_func[func_name] = config[hook_type]
			config[hook_type] = string.format('lua dein_hook_func["%s"]()', func_name)
		end
	end
	vim.fn['dein#add'](name, config)
end

vim.fn['dein#begin'](dein_dir)

-- denops.vim {{{
DeinAdd('vim-denops/denops.vim')
-- }}}

-- dein.vim {{{
DeinAdd('Shougo/dein.vim')
-- }}}

-- ddu.vim {{{
DeinAdd('Shougo/ddu.vim')
-- }}}

-- ddu-ui-ff {{{
plug_name = 'Shougo/ddu-ui-ff'
plug_config = {
	hook_add = function()
		vim.fn['ddu#custom#patch_global']({ui='ff'})
		vim.fn['ddu#custom#patch_global'](
			'uiParams',
			{
				ff = {startFilter = true}
			})

		vim.api.nvim_create_autocmd(
			'FileType',
			{
				pattern = 'ddu-ff',
				callback = function()
					vim.keymap.set('n', '<CR>', function() vim.fn['ddu#ui#do_action']('itemAction') end, {buffer=true, silent=true})
					vim.keymap.set('n', 't', function() vim.fn['ddu#ui#do_action']('itemAction', {params={command='tabnew'}}) end, {buffer=true, silent=true})
					vim.keymap.set('n', 's', function() vim.fn['ddu#ui#do_action']('itemAction', {params={command='new'}}) end, {buffer=true, silent=true})
					vim.keymap.set('n', 'v', function() vim.fn['ddu#ui#do_action']('itemAction', {params={command='vnew'}}) end, {buffer=true, silent=true})
					vim.keymap.set('n', 'i', function() vim.fn['ddu#ui#do_action']('openFilterWindow') end, {buffer=true, silent=true})
					vim.keymap.set('n', 'q', function() vim.fn['ddu#ui#do_action']('quit') end, {buffer=true, silent=true})
				end
			})

		vim.api.nvim_create_autocmd(
			'FileType',
			{
				pattern = 'ddu-ff-filter',
				callback = function()
					vim.keymap.set('n', '<CR>', '<Cmd>call ddu#ui#do_action("closeFilterWindow")<CR>', {buffer=true, silent=true})
					vim.keymap.set('i', '<CR>', '<Esc><Cmd>call ddu#ui#do_action("closeFilterWindow")<CR>', {buffer=true, silent=true})
					vim.keymap.set('n', 'q', function() vim.fn['ddu#ui#do_action']('quit') end, {buffer=true, silent=true})
				end
			})
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- ddu-kind-file {{{
plug_name = 'Shougo/ddu-kind-file'
plug_config = {
	hook_add = function()
		vim.fn['ddu#custom#patch_global'](
			'kindOptions',
			{
				file = {defaultAction = 'open'}
			})
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- ddu-filter-matcher_substring {{{
plug_name = 'Shougo/ddu-filter-matcher_substring'
plug_config = {
	hook_add = function()
		vim.fn['ddu#custom#patch_global'](
			'sourceOptions',
			{
				_ = {
					matchers = {'matcher_substring'},
					ignoreCase = true,
				}
			})
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- ddu-source-file_rec {{{
plug_name = 'Shougo/ddu-source-file_rec'
plug_config = {
	hook_add = function()
		vim.fn['ddu#custom#patch_global'](
			'sourceOptions',
			{
				file_rec = {
					path = vim.fn.expand('.')
				}
			})
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- ddc-ddc-ui-native {{{
DeinAdd('Shougo/ddc-ui-native')
-- }}}

-- ddc-matcher_head {{{
DeinAdd('Shougo/ddc-matcher_head')
-- }}}

-- ddc-sorter_rank {{{
DeinAdd('Shougo/ddc-sorter_rank')
-- }}}

-- ddc-source-around {{{
DeinAdd('Shougo/ddc-source-around')
-- }}}

-- ddc.vim {{{
plug_name = 'Shougo/ddc.vim'
plug_config = {
	hook_add = function()
		vim.fn['ddc#custom#patch_global']('ui', 'native')
		vim.fn['ddc#custom#patch_global']('sources', {'around', 'neosnippet'})
		vim.fn['ddc#custom#patch_global'](
			'sourceOptions',
			{
				_ = {
					matchers = {'matcher_head'}
				}
			})

		vim.fn['ddc#enable']()
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- neosnippet.vim {{{
plug_name = 'Shougo/neosnippet.vim'
plug_config = {
	hook_add = function()
		vim.api.nvim_set_var('neosnippet#disable_runtime_snippets', {_=1, cpp=0})
		vim.keymap.set('i', '<C-k>', '<Plug>(neosnippet_expand_or_jump)')
		vim.keymap.set('s', '<C-k>', '<Plug>(neosnippet_expand_or_jump)')
		vim.keymap.set('x', '<C-k>', '<Plug>(neosnippet_expand_target)')
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- lightline.vim {{{
plug_name = 'itchyny/lightline.vim'
plug_config = {
	hook_add = function()
		vim.api.nvim_set_var(
		'lightline',
		{
			colorscheme = 'wombat',
			component_function = {anzu = 'anzu#search_status'},
		})

		vim.api.nvim_set_var(
		'lightline.active',
		{
			left = {
				{'mode', 'paste'},
				{'readonly', 'filename', 'modified', 'anzu'},
			}
		})

		vim.api.nvim_set_var(
		'lightline.inactive',
		{
			left = {
				{'readonly', 'filename', 'modified'},
			},
			right = {
				{'lineinfo'},
				{'percent'},
				{'fileformat', 'fileencoding', 'filetype'},
			},
		})
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- vim-easy-align {{{
plug_name = 'junegunn/vim-easy-align'
plug_config = {
	hook_add = function()
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
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- vim-localvimrc {{{
plug_name = 'embear/vim-localvimrc'
plug_config = {
	hook_add = function()
		vim.api.nvim_set_var('localvimrc_ask', 0)
		vim.api.nvim_set_var('localvimrc_sandbox', 0)
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- vaffle.vim {{{
plug_name = 'cocopon/vaffle.vim'
plug_config = {
	hook_add = function()
		vim.keymap.set('n', '<C-e>', ':Vaffle %:h<CR>', {noremap=true})
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- win-ime-con.nvim {{{
plug_name = 'pepo-le/win-ime-con.nvim'
plug_config = {
	hook_add = function()
		vim.api.nvim_set_var('win_ime_con_mode', 0)
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

--- ack.vim {{{
plug_name = 'mileszs/ack.vim'
plug_config = {
	hook_add = function()
		vim.api.nvim_set_var('ackprg', 'pt')
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- vim-better-whitespace {{{
DeinAdd('ntpeters/vim-better-whitespace')
-- }}}

-- nvim-treesitter {{{
plug_name = 'nvim-treesitter/nvim-treesitter'
plug_config = {
	hook_post_source = function()
		require'nvim-treesitter.configs'.setup {
			ensure_installed = {'c', 'cpp', 'lua', 'python'},
			highlight = {
				enable = true,
			}
		}
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- hop.nvim {{{
plug_name = 'phaazon/hop.nvim'
plug_config = {
	hook_add =	function()
		require'hop'.setup {}
		vim.keymap.set('n', '<Leader>w', function() require'hop'.hint_words() end, {noremap=true})
		vim.keymap.set('n', '<Leader>s', function() require'hop'.hint_char2() end, {noremap=true})
		vim.keymap.set('n', '<Leader>l', function() require'hop'.hint_lines() end, {noremap=true})
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- memolist.vim {{{
plug_name = 'glidenote/memolist.vim'
plug_config = {
	hook_add =	function()
		vim.api.nvim_set_var('memolist_path', vim.fn.stdpath('data') .. '/memo')
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- cellwidths.nvim {{{
plug_name = 'delphinus/cellwidths.nvim'
plug_config = {
	hook_add = function()
		require'cellwidths'.setup {
			name = 'default',
			fallback = function(cw)
				cw.add(0x203B, 2)
			end,

		}
	end
}
DeinAdd(plug_name, plug_config)
-- }}}

-- previm {{{
DeinAdd('previm/previm')
-- }}}

-- open-browser.vim {{{
DeinAdd('tyru/open-browser.vim')
-- }}}

-- no-neck-pain.nvim {{{
DeinAdd('shortcuts/no-neck-pain.nvim')
-- }}}

vim.fn['dein#end']()

-- vim:set foldmethod=marker foldmarker={{{,--\ }}}:
