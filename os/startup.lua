local fsOpen = _G['fs']['open']
--local fsDelete = _G['fs']['delete']
--local fsMove = _G['fs']['move']
--local fsCopy = _G['fs']['copy']
local fsList = _G['fs']['list']
local fsIsDir = _G['fs']['isDir']
local fsExists = _G['fs']['exists']
local config = textutils.unserialize(fs.open("/zhestartup.cfg","r").readAll())
local ramdisk = {}
_G['_SYSPATH'] = "/zheos/"
settings.load("/.systemSettings")
term.clear()
term.setBackgroundColor(colors.black)
term.setCursorPos(1,1)
local getPathTable = function(path)
    local t = {}
    path:gsub("([^/]+)", function(c) table.insert(t, c) end)
    return t
end
fs.list = function(path)
    local pathTable = getPathTable(path)
    if #pathTable == 0 then
        local files = {}
        for _,v in ramdisk do
            table.insert(files,v)
        end
        return files
end
local inBootMenu = false
local i = 0
function bootMenu()
    local bootTo = 0
    term.clear()
    term.setCursorPos(1,1)
    print("ZheOS boot menu\n")
    for key, value in pairs(config.labels) do
    	print(key.." "..value.." ("..config.loadPaths[key]..")")
    end
    while true do
	term.write("Boot: ")
	bootTo = tonumber(read())
	term.clearLine()
	if config.loadPaths[bootTo] ~= nil then
            break
	end
    end
    term.clear()
    term.setCursorPos(1,1)
    ramdisk = textutils.unserialise(fs.open(config.ramDisks[bootTo]).readAll())
    shell.run(config.loadPaths[bootTo])
end
function wait()
    while i<100 or inBootMenu do
        i = i + 1
        os.sleep(0.01)
    end
    while inBootMenu do os.sleep(0) end
end
local function waitForKey()
    while true do
        local event, pressed = os.pullEvent("key")
        if pressed == keys.leftShift then
            inBootMenu = true
            bootMenu()
        end
    end
end
local function init()
    parallel.waitForAny(wait,waitForKey)
    print('booting from config.default')
    os.sleep(0.5)
    ramdisk = textutils.unserialise(fs.open(config.ramDisks[config.default]).readAll())
    shell.run(config.loadPaths[config.default])
end
local ok = pcall(init)
if not ok then
   os.reboot() 
end
