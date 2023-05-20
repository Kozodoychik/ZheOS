os.loadAPI("apis/gui.lua")
os.loadAPI("apis/threading.lua")
os.startTimer(0.01)
local appWindow = gui.newWindow("appWindow", "", false)
local appThreadID = nil
local startMenuVisible = false
local function exitApp()
    threading.stopThread(appThreadID)
    appWindow.setVisible(false)
    gui.setLabelProperty("appNameLabel", "text", "")
    gui.setWindowProperty("appWindow", "name", "")
    gui.destroyButton("exitBtn")
    appWindow.setTextColor(colors.white)
    appWindow.setBackgroundColor(colors.black)
    appWindow.clear()
    appWindow.setCursorPos(1,1)
    appThreadID = nil
end
local function runApp(path, name)
    if appThreadID then
        exitApp(appThreadID)
    end
    appWindow.setVisible(true)
    appWindow.redraw()
    gui.newButton("exitBtn", 49, 1, "X", colors.red, exitApp)
    gui.setWindowProperty("appWindow", "name", name)
    gui.setLabelProperty("appNameLabel", "text", name)
    appThreadID = threading.start(appWindow, function()
        shell.run(path)
    end)
end
local function showStartMenu()
    if startMenuVisible then
        gui.setButtonProperty("startMenuBtn", "label", ">")
        gui.destroyButton("rebootBtn")
        gui.destroyButton("testappBtn")
        startMenuVisible = false
    else
        gui.setButtonProperty("startMenuBtn", "label", "<")
        gui.newButton("rebootBtn", 1, 18, "[ Reboot  ]", colors.lightBlue, os.reboot)
        gui.newButton("testappBtn", 1, 17, "[ CraftOS ]", colors.lightBlue, function()
            showStartMenu()
            runApp("rom/programs/shell.lua", "CraftOS")
        end)
        startMenuVisible = true
    end
end
gui.init()
gui.setBGColor(colors.lightGray)
gui.newRect("rect", 1, 19, 51, 0, colors.gray)
gui.newRect("rect2", 1, 1, 51, 0, colors.gray)
gui.newButton("startMenuBtn", 1, 19, ">", colors.lightBlue, showStartMenu)
gui.newLabel("appNameLabel", 1, 1, "", colors.white, colors.gray)
threading.start(term.native(), gui.mainLoop)
threading.run()