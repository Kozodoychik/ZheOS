local fsOpen = _G['fs']['open']
local fsDelete = _G['fs']['delete']
local fsMove = _G['fs']['move']
local fsCopy = _G['fs']['copy']
local isUnlocked = settings.get("gkstartup.isUnlocked")
term.clear()
paintutils.drawImage(paintutils.loadImage("/gkos/logo.nfp"),23,5)
term.setBackgroundColor(colors.black)
term.setCursorPos(24,13)
print("GK-OS")
if isUnlocked == true then
	term.setCursorPos(22,15)
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
local inRecovery = false
local i = 0
function wait()
    while i<100 or inRecovery do
        i = i + 1
        os.sleep(0.05)
    end
end
function waitForKey()
    while true do
        local event, pressed = os.pullEvent("key")
        if pressed == keys.leftShift then
            inRecovery = true
            shell.run("/gkos/recovery/main.lua")
        end
    end
end
function init()
    parallel.waitForAny(wait,waitForKey)
    shell.run("/gkos/system/init.lua")
end
local ok = pcall(init)
if not ok then
   os.reboot() 
end
