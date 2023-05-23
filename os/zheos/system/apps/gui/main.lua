os.loadAPI("apis/mainLayout:lua")
os.loadAPI("apis/threading.lua")
os.startTimer(0.01)
local appThreadID = nil
local startMenuVisible = false
local mainLayout = gui.Layout:new()
local appWindow = mainLayout:newWindow("appWindow", "", false)
local function exitApp()
    threading.stopThread(appThreadID)
    appWindow.setVisible(false)
    mainLayout:setLabelProperty("appNameLabel", "text", "")
    mainLayout:setWindowProperty("appWindow", "name", "")
    mainLayout:destroyButton("exitBtn")
    mainLayout:setWindowProperty("appWindow", "name", "")
    appWindow.setTextColor(colors.white)
    appWindow.setBackgroundColor(colors.black)
    appWindow.clear()
    appWindow.setCursorPos(1,1)
    appThreadID = nil
end
local function runApp(path, name)
    if appThreadID ~= nil then
        exitApp(appThreadID)
    end
    threading.setUpOnError(exitApp)
    appWindow.setVisible(true)
    appWindow.redraw()
    mainLayout:newButton("exitBtn", 49, 1, "X", colors.red, exitApp)
    mainLayout:setWindowProperty("appWindow", "name", name)
    mainLayout:setLabelProperty("appNameLabel", "text", name)
    appThreadID = threading.start(appWindow, function()
        shell.run(path)
    end)
end
local function showStartMenu()
    if startMenuVisible then
        mainLayout:setButtonProperty("startMenuBtn", "label", ">")
        mainLayout:destroyButton("rebootBtn")
        mainLayout:destroyButton("craftosBtn")
        mainLayout:destroyButton("aboutBtn")
        startMenuVisible = false
    else
        mainLayout:setButtonProperty("startMenuBtn", "label", "<")
        mainLayout:newButton("rebootBtn", 1, 18, "[ Reboot  ]", colors.lightBlue, os.reboot)
        mainLayout:newButton("craftosBtn", 1, 17, "[ CraftOS ]", colors.lightBlue, function()
            showStartMenu()
            runApp("rom/programs/shell.lua", "CraftOS")
        end)
        mainLayout:newButton("aboutBtn", 1, 16, "[  About  ]", colors.lightBlue, function()
            showStartMenu()
            runApp("apps/about/main.lua", "About ZheOS")
        end)
        startMenuVisible = true
    end
end
mainLayout:init()
mainLayout:setBGColor(colors.lightGray)
mainLayout:newRect("rect", 1, 19, 51, 0, colors.gray)
mainLayout:newRect("rect2", 1, 1, 51, 0, colors.gray)
mainLayout:newButton("startMenuBtn", 1, 19, ">", colors.lightBlue, showStartMenu)
mainLayout:newLabel("appNameLabel", 1, 1, "", colors.white, colors.gray)
threading.start(term.native(), mainLayout.mainLoop)
threading.run()