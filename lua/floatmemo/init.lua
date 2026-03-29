--- *floatmemo*    Floating window memo plugin for Neovim
---
--- MIT License Copyright (c) 2025 sh1Nome
---
---@toc

--- floatmemo.nvim is a Neovim plugin to manage notes in a floating window.
--- Keep your memo in one place across all projects.
---
--- Features:
--- - Simple floating window for taking notes
--- - Auto-save to a single memo file
--- - Consistent memo file location across projects
--- - Customizable window size and appearance
---@tag floatmemo-introduction
---@toc_entry Introduction

---                                                          *:FloatmemoOpen*
--- :FloatmemoOpen          Open the floating memo window
---
---                                                         *:FloatmemoClose*
--- :FloatmemoClose         Close the floating memo window
---
---                                                        *:FloatmemoToggle*
--- :FloatmemoToggle        Toggle the floating memo window
---@tag floatmemo-commands
---@toc_entry Commands

local M = {}
local config = require("floatmemo.config")
local state = require("floatmemo.state")
local window = require("floatmemo.window")
local handlers = require("floatmemo.handlers")

--- Initialize the floatmemo plugin with user configuration.
---
---@param opts table|nil Options. Possible fields:
---   - <memo_path> `(string)` - Path to memo file. Default: plugin root + /memo.txt
---   - <width> `(number)` - Window width as percentage (0 < value <= 100). Default: 80
---   - <height> `(number)` - Window height as percentage (0 < value <= 100). Default: 80
---   - <save_on_close> `(boolean)` - Save on close (true: save, false: discard changes). Default: true
---   - <border> `(string)` - Border style ("single", "double", "shadow", "rounded", etc.). Default: "rounded"
---
---@usage
--- require('floatmemo').setup({ width = 90, height = 85 })
---
--- -- Optional: Set up key mapping
--- vim.keymap.set("n", "<leader>m", function()
---     require("floatmemo").toggle()
--- end, { desc = "Toggle floatmemo" })
---@tag floatmemo-api-setup
---@toc_entry setup()
function M.setup(opts)
	config.setup(opts)
end

--- Open the floating memo window.
---@tag floatmemo-api-open
---@toc_entry open()
function M.open()
	if state.is_open() then
		return
	end

	local buf_id = state.get_buffer()

	-- バッファが無い、または無効な場合はバッファを作成
	if not buf_id or not vim.api.nvim_buf_is_valid(buf_id) then
		local memo_path = config.get("memo_path")

		-- メモファイルが存在しない場合は作成
		if vim.fn.filereadable(memo_path) == 0 then
			vim.fn.writefile({}, memo_path)
		end

		-- bufnr()でバッファIDを取得（存在しなければ作成）
		buf_id = vim.fn.bufnr(memo_path, true)
		state.set_buffer(buf_id)

		-- バッファをバッファリストから隠す
		vim.api.nvim_set_option_value("buflisted", false, { buf = buf_id })
	end

	-- ウィンドウを作成・表示
	local win_id = window.create(buf_id)
	state.set_window(win_id)

	-- floatmemo 専用の autocommand グループを作成（重複登録を防ぐ）
	vim.api.nvim_create_augroup("floatmemo", { clear = true })

	-- ウィンドウが閉じられたら自動的にcloseを呼ぶ
	vim.api.nvim_create_autocmd("WinClosed", {
		group = "floatmemo",
		callback = function(args)
			handlers.on_win_closed(win_id, args)
		end,
	})

	-- バッファの移動があればメモバッファにフォーカスを戻す
	vim.api.nvim_create_autocmd("BufEnter", {
		group = "floatmemo",
		callback = handlers.on_buf_enter,
	})

	-- 端末がリサイズされたときにフロートウィンドウをリサイズ
	vim.api.nvim_create_autocmd("VimResized", {
		group = "floatmemo",
		callback = handlers.on_vim_resized,
	})
end

--- Close the floating memo window and cleanup resources.
---@tag floatmemo-api-close
---@toc_entry close()
function M.close()
	local buf_id = state.get_buffer()
	local win_id = state.get_window()

	if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
		-- save_on_closeが有効な場合は保存
		if config.get("save_on_close") then
			vim.api.nvim_buf_call(buf_id, function()
				vim.cmd("write")
			end)
		else
			-- save_on_closeが無効な場合は変更を破棄
			vim.api.nvim_set_option_value("modified", false, { buf = buf_id })
		end
	end

	-- ウィンドウとバッファを削除
	if win_id and vim.api.nvim_win_is_valid(win_id) then
		vim.api.nvim_win_close(win_id, true)
	end

	if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
		vim.api.nvim_buf_delete(buf_id, { force = true })
	end

	-- autocmdグループを削除
	if vim.fn.exists("augroup floatmemo") == 1 then
		vim.api.nvim_del_augroup_by_name("floatmemo")
	end

	state.clear()
end

--- Toggle the floating memo window open or closed.
---@tag floatmemo-api-toggle
---@toc_entry toggle()
function M.toggle()
	if state.is_open() then
		M.close()
	else
		M.open()
	end
end

return M
