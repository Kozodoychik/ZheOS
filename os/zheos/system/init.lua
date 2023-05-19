os.loadAPI("apis/registry.lua")
os.loadAPI("apis/gui.lua")

local function firstBootOkHandler()
	local passw = gui.getTextProperty("passwText", "text")
	local user = gui.getTextProperty("userText", "text")
	if user == "" then
		gui.setLabelProperty("warnLabel", "text", "Username cannot be empty!")
		return
	end
	registry.createKey(user,"user","username")
	fs.makeDir("user")
	fs.makeDir("user/"..user)
	fs.makeDir("user/"..user.."/apps")
	local passwFile = fs.open("user/"..user.."/.passwrd","w")
	passwFile.write(passw)
	passwFile.close()
	gui.exit()
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
	gui.init()
	gui.setBGColor(colors.lightGray)
	gui.newLabel("mainLabel", 1, 1, "ZheOS First boot", colors.white)
	gui.newButton("ok", 3, 10, "OK", colors.lightBlue, firstBootOkHandler)
	gui.newLabel("userLabel", 3, 3, "Username:", colors.white)
	gui.newText("userText", 3, 4, 20)
	gui.newLabel("passwLabel", 3, 6, "Password:", colors.white)
	gui.newText("passwText", 3, 7, 20)
	gui.newLabel("warnLabel", 3, 12, "", colors.red)
	gui.mainLoop()
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