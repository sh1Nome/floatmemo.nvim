local floatmemo = require("floatmemo")

-- コマンド定義
vim.api.nvim_create_user_command("FloatmemoOpen", function()
  floatmemo.open()
end, {})

vim.api.nvim_create_user_command("FloatmemoClose", function()
  floatmemo.close()
end, {})

vim.api.nvim_create_user_command("FloatmemoToggle", function()
  floatmemo.toggle()
end, {})
