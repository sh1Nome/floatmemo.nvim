local M = {}
local config = require("floatmemo.config")
local state = require("floatmemo.state")
local storage = require("floatmemo.storage")
local window = require("floatmemo.window")

-- メモをフロートウィンドウで開く
function M.open()
  if state.is_open() then
    return
  end
  
  local buf_id = state.get_buffer()
  
  -- バッファが無い、または無効な場合は新規作成
  if not buf_id or not vim.api.nvim_buf_is_valid(buf_id) then
    buf_id = vim.api.nvim_create_buf(false, true)
    state.set_buffer(buf_id)
    
    -- バッファを非表示化（バッファリストから隠す）
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf_id })
    vim.api.nvim_set_option_value("buflisted", false, { buf = buf_id })
    
    -- メモファイルから内容を読み込む
    local lines = storage.read()
    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
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
      if tonumber(args.match) == win_id then
        require("floatmemo").close()
      end
    end,
  })
end

-- メモウィンドウを閉じてクリーンアップ
function M.close()
  local buf_id = state.get_buffer()
  local win_id = state.get_window()
  
  -- save_on_closeが有効な場合は内容を保存
  if config.get("save_on_close") and buf_id and vim.api.nvim_buf_is_valid(buf_id) then
    local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
    storage.write(lines)
  end
  
  -- ウィンドウとバッファを削除
  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
  end
  
  if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
    vim.api.nvim_buf_delete(buf_id, { force = true })
  end
  
  state.clear()
end

-- メモウィンドウのトグル（開いてればClose、閉じてればOpen）
function M.toggle()
  if state.is_open() then
    M.close()
  else
    M.open()
  end
end

-- ユーザー設定でプラグインを初期化
function M.setup(opts)
  config.setup(opts)
end

return M
