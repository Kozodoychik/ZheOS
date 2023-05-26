function panic(msg)
	term.setBackgroundColor(colors.white)
	term.setCursorPos(1, 1)
	term.clear()
	paintutils.drawFilledBox(1, 1, 51, 3, colors.red)
	term.setTextColor(colors.white)
	term.setBackgroundColor(colors.red)
	term.setCursorPos(20, 2)
	term.write("ZheOS Crash")
	term.setTextColor(colors.red)
	term.setBackgroundColor(colors.white)
	term.setCursorPos(2, 5)
	term.write(msg)
	term.setCursorPos(2, 7)
	term.setTextColor(colors.black)
	term.write("Press any key to reboot")
	os.pullEvent("key")
	os.reboot()
end
local function kernelMain()
	for k,v in ipairs(fs.list("zheos/system/apis")) do
		print("Loading API - "..v)
		os.loadAPI("/zheos/system/apis/"..v)
	end
	os.startTimer(0.01)
	os.pullEvent = os.pullEventRaw
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
	shell.setAlias("makeimg","/zheos/system/utils/makeimg.lua")
	shell.setAlias("cat","/zheos/system/utils/cat.lua")
	if not fs.exists("zheos/system/.registry") then
		registry.createRegistry()
		registry.createKey("1.0.0", "system","systemVersion")
		registry.saveRegistry()
	end
	registry.loadRegistry()
	if not registry.keyExists("user") then
		newUserLayout:init()
		newUserLayout:dontTerminate(true)
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
	shell.run("zheos/system/apps/gui/main.lua")
end
local ok, msg = pcall(kernelMain)
if not ok then
	panic(msg)
end