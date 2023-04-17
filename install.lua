local filesToDownload = {
	"startup.lua",
	"zheos/system/init.lua",
	"zheos/system/apis/registry.lua",
	"zheos/sytsem/apis/threading.lua",
	"zheos/system/apps/pkg/main.lua",
	"zheos/system/utils/makeimg.lua",
	"zheos/recovery/init.lua"
}
function download(filename)
	local req = http.get("https://raw.githubusercontent.com/Kozodoychik/ZheOS/1.0.0/os/"..filename)
	local file = fs.open("/"..filename,"w")
	file.write(req.readAll())
	file.close()
end
term.setBackgroundColor(1)
term.setTextColor(128)
term.clear()
term.setCursorPos(18,8)
term.write("ZheOS v1.0.0 Setup")
term.setCursorPos(15,10)
for key, v in ipairs(filesToDownload) do
	term.clearLine()
	term.setCursorPos(15,10)
	term.write(v)
	download(v)
end
term.clearLine()
term.setCursorPos(15,10)
term.write("Installing packages...")
shell.setAlias("pkg","/zheos/system/apps/pkg/main.lua")
shell.run("pkg","install","recovery","/zheos/recovery","silent")
settings.set("zhestartup.isUnlocked",false)
settings.save("/.systemSettings")
fs.delete("/.temp")
fs.makeDir("/zheos/user")
fs.makeDir("/zheos/system/user")
fs.makeDir("/zheos/system/rom")
fs.makeDir("/zheos/recovery/rom")
term.clearLine()
term.setCursorPos(15,10)
term.write("Creating startup config...")
local cfg = {default=1,loadPaths={"/zheos/system/","/zheos/recovery/","/"},labels={"ZheOS Init","Recovery","CraftOS"}}
local cfgFile = fs.open("/zhestartup.cfg","w")
cfgFile.write(textutils.serialize(cfg))
cfgFile.close()
term.clearLine()
term.setCursorPos(15,10)
term.write("Done! Press any key to reboot")
os.pullEvent("key")
os.reboot()
