local M = {}
local state = require("floatmemo.state")

-- BufEnterイベントハンドラー：メモバッファへのフォーカスを強制
function M.on_buf_enter()
  local win_id = state.get_window()
  local buf_id = state.get_buffer()

  if not win_id or not vim.api.nvim_win_is_valid(win_id) then
    return
  end

  if not buf_id or not vim.api.nvim_buf_is_valid(buf_id) then
    return
  end

  if vim.api.nvim_get_current_win() ~= win_id then
    return
  end

  if vim.api.nvim_win_get_buf(win_id) == buf_id then
    return
  end

  vim.api.nvim_set_current_buf(buf_id)
end

-- WinClosedイベントハンドラー：ウィンドウが閉じられたときにクリーンアップ
function M.on_win_closed(win_id, args)
  if tonumber(args.match) == win_id then
    require("floatmemo").close()
  end
end

return M
