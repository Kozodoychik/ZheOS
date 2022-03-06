local fsOpen = _G['fs']['open']
local fsDelete = _G['fs']['delete']
local fsMove = _G['fs']['move']
local fsCopy = _G['fs']['copy']
local config = textutils.unserialize(fs.open("/gkstartup.cfg","r").readAll())
settings.load("/.systemSettings")
local isUnlocked = settings.get("gkstartup.isUnlocked")
term.clear()
term.setBackgroundColor(colors.black)
term.setCursorPos(24,9)
print("GK-OS")
if isUnlocked == true then
	term.setCursorPos(22,11)
	print("Unlocked!")
end
_G['fs']['open'] = function(path,dest)
   if shell.resolveProgram(path) == shell.resolveProgram("/startup.lua") and isUnlocked == false then
        error("Access denied",0)
        return nil
   else
        return fsOpen(path,dest)
   end
end
_G['fs']['move'] = function(path,mode)
   if shell.resolveProgram(path) == shell.resolveProgram("/startup.lua") and isUnlocked == false then
        error("Access denied",0)
        return nil
   else
        return fsMove(path,mode)
   end
end
_G['fs']['copy'] = function(path,mode)
   if shell.resolveProgram(path) == shell.resolveProgram("/startup.lua") and isUnlocked == false then
        error("Access denied",0)
        return nil
   else
        return fsCopy(path,mode)
   end
end
_G['fs']['delete'] = function(path)
   if shell.resolveProgram(path) == shell.resolveProgram("/startup.lua") and isUnlocked == false then
        error("Access denied",0)
        return nil
   else
        return fsDelete(path)
   end
end
local inBootMenu = false
local i = 0
function bootMenu()
    local bootTo = 0
    term.clear()
    term.setCursorPos(1,1)
    print("GK-OS boot menu\n")
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
    shell.run(config.loadPaths[config.default])
end
local ok = pcall(init)
if not ok then
   os.reboot() 
end
