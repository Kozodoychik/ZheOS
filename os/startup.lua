--ZheOS Loader
local config = textutils.unserialize(fs.open("/zhestartup.cfg","r").readAll())
settings.load("/.systemSettings")
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
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(1,1)
    term.clear()
    shell.run(config.loadPaths[bootTo])
end
function wait()
    while i<3 or inBootMenu do
        if not inBootMenu then
            term.setCursorPos(23, 11)
            if i%3==0 then
                term.write("###")
            elseif i%3==1 then
                term.write("## ")
            elseif i%3==2 then
                term.write("#  ")
            end
        end
        i = i + 1
        os.sleep(1)
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
    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.gray)
    term.clear()
    term.setCursorPos(22,9)
    term.write("ZheOS")
    term.setCursorPos(1,19)
    term.write("Press LSHIFT to enter boot menu")
    parallel.waitForAny(wait,waitForKey)
    term.setCursorPos(1,1)
    os.sleep(0.5)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(1,1)
    term.clear()
    shell.run(config.loadPaths[config.default])
end
init()