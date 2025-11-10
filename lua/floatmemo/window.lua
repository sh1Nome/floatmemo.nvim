local M = {}
local config = require("floatmemo.config")

-- フロートウィンドウを作成して表示
function M.create(buf_id, lines)
  local width_percent = config.get("width")
  local height_percent = config.get("height")
  
  -- 現在のUI寸法を取得
  local ui = vim.api.nvim_list_uis()[1]
  local screen_width = ui.width
  local screen_height = ui.height
  
  -- ウィンドウサイズと位置を計算（画面中央に配置）
  local width = math.floor(screen_width * width_percent / 100)
  local height = math.floor(screen_height * height_percent / 100)
  
  local col = math.floor((screen_width - width) / 2)
  local row = math.floor((screen_height - height) / 2)
  
  local win_id = vim.api.nvim_open_win(buf_id, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = config.get("border"),
  })
  
  return win_id
end

return M
