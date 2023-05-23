local filesToDownload = {
	"startup.lua",
	"zheos/system/init.lua",
	"zheos/system/apis/registry.lua",
	"zheos/system/apis/threading.lua",
	"zheos/system/apis/gui.lua",
	"zheos/system/apps/gui/main.lua",
	"zheos/system/apps/about/main.lua",
	"zheos/system/utils/makeimg.lua",
	"zheos/system/utils/cat.lua",
	"zheos/recovery/init.lua"
}

local function preLoad()
	print("Downloading GUI API...")
	local req = http.get("https://raw.githubusercontent.com/Kozodoychik/ZheOS/1.0.0/os/zheos/system/apis/gui.lua")
	local file = fs.open("/.temp/gui.lua","w")
	file.write(req.readAll())
	file.close()
	os.loadAPI("/.temp/gui.lua")
end
preLoad()
local function download(filename)
	local req = http.get("https://raw.githubusercontent.com/Kozodoychik/ZheOS/1.0.0/os/"..filename)
	local file = fs.open("/"..filename,"w")
	file.write(req.readAll())
	file.close()
end
local layout = gui.Layout:new()
local function install()
	layout:destroyButton("installBtn")
	layout:destroyButton("exitBtn")
	layout:newProgressBar("progress", 2, 10, 49, colors.lightBlue, colors.gray, 0)
	layout:newLabel("file", 2, 9, "", colors.gray)
	for key, v in ipairs(filesToDownload) do
		layout:setLabelProperty("file", "text", v)
		download(v)
		layout:setProgressProperty("progress", "progress", (key/#filesToDownload)*100)
		layout:redraw()
	end
	layout:exit()
end

local function makeDirs()
	fs.delete("/.temp")
	fs.makeDir("/zheos/user")
end

local function createConfig()
	local cfg = {default=1,loadPaths={"/zheos/system/kernel.lua","/zheos/recovery/init.lua","/rom/programs/shell.lua"},labels={"ZheOS Init","Recovery","CraftOS"}}
	local cfgFile = fs.open("/zhestartup.cfg","w")
	cfgFile.write(textutils.serialize(cfg))
	cfgFile.close()
end

layout:init()
layout:setBGColor(colors.lightGray)
layout:newLabel("mainLabel", 1, 1, "ZheOS 1.0.0 Setup", colors.gray)
layout:newButton("installBtn", 21, 11, "Install", colors.lightBlue, install)
layout:newButton("exitBtn", 2, 18, "Exit", colors.lightBlue, os.reboot)
layout:mainLoop()
makeDirs()
createConfig()
os.reboot()
