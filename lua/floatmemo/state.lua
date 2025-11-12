local M = {}

local state = {
  buffer_id = nil,
  window_id = nil,
}

-- バッファIDを保存
function M.set_buffer(buf_id)
  state.buffer_id = buf_id
end

function M.get_buffer()
  return state.buffer_id
end

-- ウィンドウIDを保存
function M.set_window(win_id)
  state.window_id = win_id
end

function M.get_window()
  return state.window_id
end

-- ウィンドウが現在開いているかどうかを確認
function M.is_open()
  local win_id = state.window_id
  return (win_id and vim.api.nvim_win_is_valid(win_id)) or false
end

-- 状態をリセット（ウィンドウ閉じる時に呼ぶ）
function M.clear()
  state.buffer_id = nil
  state.window_id = nil
end

return M
