os.loadAPI(_SYSPATH.."system/apis/registry.lua")
local luaPrint = _G['print']
_G['print'] = function(str, ...)
	if str then
		luaPrint("[ "..os.clock().." ] "..str)
	end
end
local luaFileList = _G['fs']['list']
local luaIsDir = _G['fs']['isDir']
local luaOpen = _G['fs']['open']
local luaExists = _G['fs']['exists']
_G['fs']['list'] = function(path)
	if path == "test" then
		return {'test.lua'}
	else
		return luaFileList(path)
	end
end
_G['fs']['isDir'] = function(path)
	if path == "test" then
		return true
	else
		return luaIsDir(path)
	end
end
_G['fs']['open'] = function(path, mode)
	if path == "test/test.lua" and mode == "r" then
		local handle = {}
		handle.readAll = function()
			return "print('Hello')"
		end
		handle.readLine = function()
			return "print('Hello')"
		end
		handle.close = function()

		end
		return handle
	else
		return luaOpen(path, mode)
	end
end
_G['fs']['exists'] = function(path)
	if path == "test" or path == "test/test.lua" then
		return true
	else
		return luaExists(path)
	end
end
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1,1)
shell.setAlias("pkg",_SYSPATH.."system/apps/pkg/main.lua")
if not fs.exists(_SYSPATH.."system/.registry") then
	print("first boot. creating user")
	fs.makeDir(_SYSPATH.."system/.registry")
	registry.createReg()
	registry.createKey("system","systemVersion","1.0.0")
	print("Type username and press Enter")
	local user = read()
	print("Type password and press Enter")
	local passw = read()
	print("writing to registry")
	registry.createKey("user","username",user)
	fs.makeDir(_SYSPATH.."user")
	fs.makeDir(_SYSPATH.."user/"..user)
	fs.makeDir(_SYSPATH.."user/"..user.."/apps")
	local passwFile = fs.open(_SYSPATH.."user/"..user.."/.passwrd","w")
	passwFile.write(passw)
	passwFile.close()
	print("installing packages")
	shell.run("pkg","install","gui",_SYSPATH.."system/apps/gui")
end
_G['print'] = luaPrint
if fs.exists(_SYSPATH.."system/apps/gui/main.lua") then
	shell.run(_SYSPATH.."system/apps/gui/main.lua")
else
	printf("No GUI app. Starting CraftOS...")
end