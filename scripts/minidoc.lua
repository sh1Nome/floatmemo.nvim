local minidoc = require("mini.doc")

if _G.MiniDoc == nil then
	minidoc.setup()
end

MiniDoc.generate({ "lua/floatmemo/init.lua" }, "doc/floatmemo.txt")
