os.loadAPI("apis/registry.lua")
local luaPrint = _G['print']
_G['print'] = function(str, ...)
	if str then
		luaPrint("[ "..os.clock().." ] "..str)
	end
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
	print("first boot. creating user")
	registry.createRegistry()
	registry.createKey("1.0.0", "system","systemVersion")
	print("Type username and press Enter")
	local user = read()
	print("Type password and press Enter")
	local passw = read()
	print("writing to registry")
	registry.createKey(user,"user","username")
	fs.makeDir("user")
	fs.makeDir("user/"..user)
	fs.makeDir("user/"..user.."/apps")
	local passwFile = fs.open("user/"..user.."/.passwrd","w")
	passwFile.write(passw)
	passwFile.close()
	print("installing packages")
	shell.run("pkg","install","gui","apps/gui")
	registry.saveRegistry()
end
registry.loadRegistry()
_G['print'] = luaPrint
if fs.exists("apps/gui/main.lua") then
	shell.run("apps/gui/main.lua")
else
	print("No GUI app. Starting CraftOS...")
	shell.run("rom/programs/shell.lua")
end