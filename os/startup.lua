--ZheOS Loader
local config = textutils.unserialize(fs.open("/zhestartup.cfg","r").readAll())
settings.load("/.systemSettings")
local inBootMenu = false
local i = 0

function bootMenu()
    term.clear()
    paintutils.drawFilledBox(1, 1, 51, 3, colors.gray)
    term.setBackgroundColor(colors.gray)
    term.setTextColor(colors.white)
    term.setCursorPos(20, 2)
    term.write("Boot menu")
    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.black)
    local y = 5
    for k,v in ipairs(config.labels) do
        term.setCursorPos(2, y)
        term.write(k..". "..v.." ("..config.loadPaths[k]..")")
        y = y + 1
    end
    term.setCursorPos(2, y)
    term.write(tostring(#config.labels+1)..". Edit config")
    local event, num = os.pullEvent("char")
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(1, 1)
    term.clear()
    if tonumber(num) == nil then
        os.reboot()
    end
    if tonumber(num) == #config.labels+1 then
        shell.run("edit", "/zhestartup.cfg")
        os.reboot()
    end
    shell.run(config.loadPaths[tonumber(num)])
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