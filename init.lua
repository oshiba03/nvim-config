-- 環境パス設定
vim.api.nvim_set_var('python_host_prog', vim.fn.expand('~/.venv/neovim2/Scripts/python.exe'))
vim.api.nvim_set_var('python3_host_prog', vim.fn.expand('~/.venv/neovim3/Scripts/python.exe'))

-- マップリーダーの設定
vim.api.nvim_set_var('mapleader', ' ')

-- プラグイン
require('plugin')

-- カラースキーマ
vim.api.nvim_command('colorscheme molokai')

-- シンタックスを有効
vim.api.nvim_command('syntax enable')

-- ファイルエンコード
vim.opt.fileencodings = {'ucs-bom', 'utf-8', 'cp932', 'sjis', 'default', 'latin'}

-- タブ
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0

-- 番号の表示
vim.opt.number = true

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- バックアップ系ファイル不要
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.clipboard = 'unnamed'
vim.opt.shortmess:append('I')

-- 行頭/行末でカーソルを止めない
vim.opt.whichwrap = 'b', 's', 'h', 'l', '<', '>', '[', ']', '~'
vim.opt.completeopt = 'preview'
vim.opt.autoread = true

-- IME
vim.opt.iminsert = 0
vim.opt.imsearch = 0

-- 読んだファイルにEOLがなければそれを維持
vim.opt.fixeol = false

-- ウィンドウのタイトルにファイル名を表示
vim.opt.title = true

-- 折り返ししない
vim.opt.wrap = false

-- プレビューウィンドウを表示しない
vim.opt.completeopt:remove('preview')

-- 曖昧文字幅
vim.opt.ambiwidth = 'double'

-- ノーマルモードでも改行
vim.keymap.set('n', '<CR>', ':execute "normal o"<CR>', {noremap=true})
vim.keymap.set('n', '<S-CR>', ':execute "normal O"<CR>', {noremap=true})

-- Esc代行
vim.keymap.set('i', '<C-j>', '<Esc>')
vim.keymap.set('v', '<C-j>', '<Esc>')
vim.keymap.set('i', '<Esc>', '<Esc>:set iminsert=0<CR>', {noremap=true})

-- 強調表示解除
vim.keymap.set('n', '<C-n>', ':noh<CR>', {noremap=true, silent=true})

-- Include展開
vim.keymap.set('n', 'gh', ':wincmd f<CR>', {noremap=true})
vim.keymap.set('n', 'gv', ':vertical wincmd f<CR>', {noremap=true})

-- タグジャンプ
vim.keymap.set('n', '<C-]>', 'g<C-]>', {noremap=true})

-- コマンドラインでの貼り付け
vim.keymap.set('c', '<S-Insert>', '<C-R>*')

-- ファイルタイプ設定
vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = '*.xaml',
		callback = function() vim.filetype.match('xaml') end
	})

-- QuickFixを下に表示する
vim.api.nvim_create_autocmd(
	'FileType',
	{
		pattern = 'qf',
		callback = function() vim.api.nvim_command('wincmd J') end
	})

-- 改行時にコメントを続けない
vim.api.nvim_create_augroup('not_keep_comment', {})
vim.api.nvim_create_autocmd(
	'BufEnter',
	{
		group = 'not_keep_comment',
		callback = function()
			vim.opt_local.formatoptions:remove('r')
			vim.opt_local.formatoptions:remove('o')
		end
	});

-- nvimフォーカス時にファイル外部変更をチェック
vim.api.nvim_create_autocmd(
	'FocusGained',
	{
		callback = function() vim.api.nvim_command('checktime') end
	})

-- タブを閉じたら左のタブに移動
vim.api.nvim_create_autocmd(
	'TabClosed',
	{
		callback = function() vim.api.nvim_command('tabp') end
	})

-- 今開いているファイルのディレクトリに移動
vim.api.nvim_create_user_command('Cdpwd', 'cd %:h', {})

-- 現在のファイパスをクリップボードにコピー
vim.api.nvim_create_user_command(
	'Copyfilepath',
	'let @* = expand("%:p") | echo @*',
	{})

vim.api.nvim_create_user_command(
	'Copyfilename',
	'let @* = expand("%:t") | echo @*',
	{})

-- init.luaを開く
vim.api.nvim_create_user_command(
	'OpenInit',
	'tabnew ' .. vim.fn.expand('<sfile>:p'),
	{})

-- plugins.luaを開く
vim.api.nvim_create_user_command(
	'OpenPlug',
	'tabnew ' .. vim.fn.expand('<sfile>:h') .. '/lua/plugin.lua',
	{})

-- xml、htmlなどのタグジャンプ
vim.cmd('source $VIMRUNTIME/macros/matchit.vim')
