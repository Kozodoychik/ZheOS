local filesToDownload = {
	"startup.lua",
	"zheos/system/init.lua",
	"zheos/system/apis/registry.lua",
	"zheos/system/apis/threading.lua",
	"zheos/system/apis/gui.lua",
	"zheos/system/apps/pkg/main.lua",
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

local function download(filename)
	local req = http.get("https://raw.githubusercontent.com/Kozodoychik/ZheOS/1.0.0/os/"..filename)
	local file = fs.open("/"..filename,"w")
	file.write(req.readAll())
	file.close()
end

local function install()
	gui.destroyButton("installBtn")
	gui.newProgressBar("progress", 2, 10, 49, colors.lightBlue, colors.gray, 0)
	gui.newLabel("file", 2, 9, "", colors.gray)
	for key, v in ipairs(filesToDownload) do
		gui.setLabelProperty("file", "text", v)
		download(v)
		gui.setProgressProperty("progress", "progress", (key/#filesToDownload)*100)
		gui.redraw()
	end
	gui.exit()
end

local function makeDirs()
	fs.delete("/.temp")
	fs.makeDir("/zheos/user")
	fs.makeDir("/zheos/system/user")
	fs.makeDir("/zheos/system/rom")
	fs.makeDir("/zheos/recovery/rom")
end

local function createConfig()
	local cfg = {default=1,loadPaths={"/zheos/system/","/zheos/recovery/","/"},labels={"ZheOS Init","Recovery","CraftOS"}}
	local cfgFile = fs.open("/zhestartup.cfg","w")
	cfgFile.write(textutils.serialize(cfg))
	cfgFile.close()
end

preLoad()
gui.init()
gui.setBGColor(colors.lightGray)
gui.newLabel("mainLabel", 1, 1, "ZheOS 1.0.0 Setup", colors.gray)
gui.newButton("installBtn", 21, 8, "Install", colors.lightBlue, install)
gui.newButton("exitBtn", 23, 10, "Exit", colors.lightBlue, os.reboot)
gui.mainLoop()
makeDirs()
createConfig()
os.reboot()
