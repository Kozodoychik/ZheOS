local filesToDownload = {
	"startup.lua",
	"zheos/system/init.lua",
	"zheos/system/apis/registry.lua",
	"zheos/system/apis/threading.lua",
	"zheos/system/apps/pkg/main.lua",
	"zheos/system/utils/makeimg.lua",
	"zheos/system/utils/cat.lua",
	"zheos/recovery/init.lua"
}
function download(filename, ...)
	local req = http.get("https://raw.githubusercontent.com/Kozodoychik/ZheOS/1.0.0/os/"..filename)
	if ... == nil then
		local file = fs.open("/"..filename,"w")
	else
		local file = fs.open(..., "w")
	end
	file.write(req.readAll())
	file.close()
end

function install()
	gui.destroyButton(installBtn)
	for key, v in ipairs(filesToDownload) do
		term.clearLine()
		term.setCursorPos(15,10)
		term.write(v)
		download(v)
		gui.setProgressProperty("progress", "progress", (#filesToDownload/100)*key)
	end
	gui.exit()
end
print("Downloading GUI API...")
download("zheos/system/apis/gui.lua", "/.temp/gui.lua")
os.loadAPI("/.temp/gui.lua")
gui.init()
gui.setBGColor(colors.white)
gui.newLabel("mainLabel", 1, 1, "ZheOS 1.0.0 Setup", colors.lightGray)
gui.newButton("installBtn", 2, 3, "Install", colors.lime, install)
gui.newProgressBar("progress", 2, 10, 49, colors.lime, 0)
gui.mainLoop()

fs.delete("/.temp")
fs.makeDir("/zheos/user")
fs.makeDir("/zheos/system/user")
fs.makeDir("/zheos/system/rom")
fs.makeDir("/zheos/recovery/rom")

local cfg = {default=1,loadPaths={"/zheos/system/","/zheos/recovery/","/"},labels={"ZheOS Init","Recovery","CraftOS"}}
local cfgFile = fs.open("/zhestartup.cfg","w")
cfgFile.write(textutils.serialize(cfg))
cfgFile.close()

os.reboot()
