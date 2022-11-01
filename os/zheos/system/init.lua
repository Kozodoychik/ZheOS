os.loadAPI(_SYSPATH.."system/apis/registry.lua")
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
shell.run(_SYSPATH.."system/apps/gui/main.lua")
