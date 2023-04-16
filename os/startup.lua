os.loadAPI("/bootloader/mountdriver.lua")
local config = textutils.unserialize(fs.open("/zhestartup.cfg","r").readAll())
_G['_SYSPATH'] = "/zheos/"
settings.load("/.systemSettings")
term.clear()
term.setBackgroundColor(colors.black)
term.setCursorPos(1,1)
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
    shell.run(config.loadPaths[config.default])
end
local ok = pcall(init)
if not ok then
   os.reboot() 
end
