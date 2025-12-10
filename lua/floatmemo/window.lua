local M = {}
local config = require("floatmemo.config")

-- ウィンドウの幅・高さ・位置を計算（画面中央に配置）
local function calculate_geometry()
  local width_percent = config.get("width")
  local height_percent = config.get("height")
  local border = config.get("border")
  
  -- 現在のUI寸法を取得
  local ui = vim.api.nvim_list_uis()[1]
  local screen_width = ui.width
  local screen_height = ui.height
  
  -- サイズと位置を計算
  local width = math.floor(screen_width * width_percent / 100)
  local height = math.floor(screen_height * height_percent / 100)
  
  local col = math.floor((screen_width - width) / 2)
  local row = math.floor((screen_height - height) / 2)
  
  -- ボーダーがある場合は位置を調整
  if border and border ~= "none" then
    col = col - 1
    row = row - 1
  end
  
  return { width = width, height = height, col = col, row = row }
end

-- フロートウィンドウを作成して表示
function M.create(buf_id, lines)
  local geometry = calculate_geometry()
  
  local win_id = vim.api.nvim_open_win(buf_id, true, {
    relative = "editor",
    width = geometry.width,
    height = geometry.height,
    col = geometry.col,
    row = geometry.row,
    border = config.get("border"),
  })
  
  -- ウィンドウの背景色をNeovimの背景色に統一
  vim.api.nvim_set_option_value("winhighlight", "Normal:Normal,FloatBorder:Normal", { win = win_id })
  
  return win_id
end

-- フロートウィンドウをリサイズ
function M.resize(win_id)
  if not win_id or not vim.api.nvim_win_is_valid(win_id) then
    return
  end
  
  local geometry = calculate_geometry()
  
  vim.api.nvim_win_set_config(win_id, {
    relative = "editor",
    width = geometry.width,
    height = geometry.height,
    col = geometry.col,
    row = geometry.row,
  })
end

return M
