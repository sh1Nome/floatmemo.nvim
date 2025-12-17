local M = {}
local config = require("floatmemo.config")
local state = require("floatmemo.state")
local window = require("floatmemo.window")
local handlers = require("floatmemo.handlers")

-- メモをフロートウィンドウで開く
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

-- メモウィンドウを閉じてクリーンアップ
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
