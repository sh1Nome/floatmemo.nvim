local M = {}

local defaults = {
  memo_path = nil,
  width = 80,
  height = 80,
  save_on_close = true,
  border = "rounded",
}

local config = {}

-- ユーザーの設定オプションで初期化
function M.setup(opts)
  config = vim.tbl_deep_extend("force", defaults, opts or {})
  
  -- memo_pathが未指定の場合は自動計算
  if config.memo_path == nil then
    -- debug.getinfo(1).sourceで現在のLuaファイルのパスを取得
    -- 例: @/home/user/.local/share/nvim/site/pack/packer/start/floatmemo.nvim/lua/floatmemo/config.lua
    -- sub(2)で先頭の@を削除
    -- match("(.*)/")で最後のスラッシュまでの部分を抽出（ディレクトリ部分）
    -- 結果: /home/user/.local/share/nvim/site/pack/packer/start/floatmemo.nvim/lua/floatmemo/
    local script_dir = debug.getinfo(1).source:sub(2):match("(.*)/")
    
    -- script_dirから /lua/floatmemo/ より前の部分を抽出
    -- match("(.*)/lua")でluaフォルダより前のプラグインルートを取得
    -- 結果: /home/user/.local/share/nvim/site/pack/packer/start/floatmemo.nvim
    -- その後 /memo.txt を末尾に追加してmemo_pathを確定
    config.memo_path = script_dir:match("(.*)/lua") .. "/memo.txt"
  end
  
  return config
end

-- キーを指定すればその値、省略すれば全設定を取得
function M.get(key)
  if key then
    return config[key]
  end
  return config
end

return M
