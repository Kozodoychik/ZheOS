os.loadAPI("apis/gui.lua")
os.loadAPI("apis/threading.lua")
local startMenuVisible = false
local function showStartMenu()
    if startMenuVisible then
        gui.setButtonProperty("startMenuBtn", "label", ">")
        gui.destroyButton("rebootBtn")
        startMenuVisible = false
    else
        gui.setButtonProperty("startMenuBtn", "label", "<")
        gui.newButton("rebootBtn", 1, 2, "[ Reboot ]", colors.lightBlue, os.reboot)
        startMenuVisible = true
    end
end
gui.init()
gui.setBGColor(colors.lightGray)
gui.newRect("rect", 1, 1, 59, 0, colors.gray)
gui.newButton("startMenuBtn", 1, 1, ">", colors.lightBlue, showStartMenu)
gui.mainLoop()
