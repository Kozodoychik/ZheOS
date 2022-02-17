os.loadAPI("/ospixel/system/apis/registry.lua")
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1,1)
if not fs.exists("/ospixel/system/.registry") then
	fs.makeDir("/ospixel/system/.registry")
	registry.createReg()
	registry.createKey("system","systemVersion","1.0.0")
	term.write("Username: ")
	local user = read()
	registry.createKey("user","username",user)
end
shell.run("/ospixel/system/apps/gui/main.lua")
