local M = {}
local config = require("floatmemo.config")

-- メモファイルから内容を読み込む
function M.read()
  local path = config.get("memo_path")
  local file = io.open(path, "r")
  
  if not file then
    return {}
  end
  
  local content = file:read("*a")
  file:close()
  
  if content == "" then
    return {}
  end
  
  local lines = {}
  for line in content:gmatch("[^\n]*") do
    table.insert(lines, line)
  end
  
  return lines
end

-- メモ内容をファイルに書き込む
function M.write(lines)
  local path = config.get("memo_path")
  local file = io.open(path, "w")
  
  if not file then
    vim.notify("Error: Failed to open memo file for writing: " .. path, vim.log.levels.ERROR)
    return false
  end
  
  file:write(table.concat(lines, "\n"))
  file:close()
  
  return true
end

return M
