os.loadAPI("apis/registry.lua")
os.loadAPI("apis/gui.lua")
local newUserLayout = gui.Layout:new()
local function firstBootOkHandler()
	local passw = newUserLayout:getTextProperty("passwText", "text")
	local user = newUserLayout:getTextProperty("userText", "text")
	if user == "" then
		newUserLayout:setLabelProperty("warnLabel", "text", "Username cannot be empty!")
		return
	end
	registry.createKey(user,"user","username")
	fs.makeDir("user")
	fs.makeDir("user/"..user)
	fs.makeDir("user/"..user.."/apps")
	local passwFile = fs.open("user/"..user.."/.passwrd","w")
	passwFile.write(passw)
	passwFile.close()
	newUserLayout:exit()
end

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1,1)
print("Mounting user...")
mounter.mount("zheos/user","user")
shell.setAlias("pkg","apps/pkg/main.lua")
shell.setAlias("makeimg","utils/makeimg.lua")
shell.setAlias("cat","utils/cat.lua")
if not fs.exists(".registry") then
	registry.createRegistry()
	registry.createKey("1.0.0", "system","systemVersion")
	newUserLayout:init()
	newUserLayout:setBGColor(colors.lightGray)
	newUserLayout:newLabel("mainLabel", 1, 1, "ZheOS First boot", colors.white)
	newUserLayout:newButton("ok", 3, 10, "OK", colors.lightBlue, firstBootOkHandler)
	newUserLayout:newLabel("userLabel", 3, 3, "Username:", colors.white)
	newUserLayout:newText("userText", 3, 4, 20)
	newUserLayout:newLabel("passwLabel", 3, 6, "Password:", colors.white)
	newUserLayout:newText("passwText", 3, 7, 20)
	newUserLayout:newLabel("warnLabel", 3, 12, "", colors.red)
	newUserLayout:mainLoop()
	--print("installing packages")
	--shell.run("pkg","install","gui","apps/gui")
	registry.saveRegistry()
end
registry.loadRegistry()
if fs.exists("apps/gui/main.lua") then
	shell.run("apps/gui/main.lua")
else
	print("No GUI app. Starting CraftOS...")
	shell.run("rom/programs/shell.lua")
end