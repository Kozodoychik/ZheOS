local appThreadID = nil
local startMenuVisible = false
local mainLayout = gui.Layout:new()
local appWindow = mainLayout:newWindow("appWindow", "", 1, 2, 51, 17, false)
local notifyWindow = mainLayout:newWindow("notifyWindow", "", 51, 13, 20, 5, false)
term.redirect(notifyWindow)
local notifyLayout = gui.Layout:new()
notifyLayout:init()
notifyLayout:setBGColor(colors.white)
notifyLayout:newRect("headerRect", 1, 1, 20, 0, colors.gray)
notifyLayout:newLabel("header", 1, 1, "Header", colors.white, colors.gray)
notifyLayout:newLabel("text", 2, 3, "Text", colors.black, colors.white)
term.redirect(term.native())
local function clearWindow()
    appWindow.setVisible(false)
    mainLayout:setLabelProperty("appNameLabel", "text", "")
    mainLayout:setWindowProperty("appWindow", "name", "")
    mainLayout:destroyButton("exitBtn")
    mainLayout:setWindowProperty("appWindow", "name", "")
    appWindow.setTextColor(colors.white)
    appWindow.setBackgroundColor(colors.black)
    appWindow.clear()
    appWindow.setCursorPos(1,1)
end
local function exitApp()
    threading.stopThread(appThreadID)
    clearWindow()
    appThreadID = nil
end
local function prepareWindow(name)
    if appThreadID ~= nil then
        exitApp(appThreadID)
    end
    threading.setUpOnError(exitApp)
    threading.setUpOnStop(exitApp)
    appWindow.setVisible(true)
    appWindow.redraw()
    mainLayout:newButton("exitBtn", 49, 1, "X", colors.red, exitApp)
    mainLayout:setWindowProperty("appWindow", "name", name)
    mainLayout:setLabelProperty("appNameLabel", "text", name)
end
local function runApp(path, name)
    prepareWindow(name)
    appThreadID = threading.start(appWindow, function()
        shell.run(path)
    end)
end
local function appsMenu()
    local appsLayout = gui.Layout:new()
    appsLayout:init()
    appsLayout:setBGColor(colors.lightBlue)
    local y = 2
    for k,v in ipairs(fs.list("zheos/system/apps")) do
        if v ~= "gui" then
            appsLayout:newButton("appsBtn"..k, 3, y, v, colors.lightGray, function()
                runApp("zheos/system/apps/"..v.."/main.lua", "")
            end)
            y = y + 2
        end
    end
    appsLayout:mainLoop()
end
local function showStartMenu()
    if startMenuVisible then
        mainLayout:setButtonProperty("startMenuBtn", "label", ">")
        mainLayout:destroyButton("rebootBtn")
        mainLayout:destroyButton("craftosBtn")
        mainLayout:destroyButton("aboutBtn")
        mainLayout:destroyButton("appsBtn")
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
            runApp("zheos/system/apps/about/main.lua", "About")
        end)
        mainLayout:newButton("appsBtn", 1, 15, "[  Apps   ]", colors.lightBlue, function()
            showStartMenu()
            prepareWindow("Apps")
            appThreadID = threading.start(appWindow, appsMenu)
        end)
        startMenuVisible = true
    end
end
local function peripheralNotification()
    while true do
        local event, side = os.pullEvent("peripheral")
        os.notify("New peripheral on the "..side, peripheral.getType(side).." has been attached")
    end
end
_G.os.setWindowLabel = function(label)
    mainLayout:setLabelProperty("appNameLabel", "text", label)
    mainLayout:setWindowProperty("appWindow", "name", label)
    os.queueEvent("timer")
end
_G.os.notify = function(header, text)
    notifyLayout:setLabelProperty("header", "text", header)
    notifyLayout:setLabelProperty("text", "text", text)
    notifyWindow.setVisible(true)
    for i=1,20 do
        notifyWindow.reposition(51-i, 13)
        os.queueEvent("timer")
        mainLayout:redraw()
        os.sleep(0.005)
    end
    for i=0,1 do
        coroutine.yield()
    end
    for i=1,20 do
        notifyWindow.reposition(31+i, 13)
        os.queueEvent("timer")
        mainLayout:redraw()
        os.sleep(0.005)
    end
    notifyWindow.setVisible(false)
end
mainLayout:init()
mainLayout:setBGColor(colors.lightGray)
mainLayout:newRect("rect", 1, 19, 51, 0, colors.gray)
mainLayout:newRect("rect2", 1, 1, 51, 0, colors.gray)
--mainLayout:newImage("test", 3, 3, 5, 4, "/zheos/system/res/folder.nft", true, false)
mainLayout:newButton("startMenuBtn", 1, 19, ">", colors.lightBlue, showStartMenu)
mainLayout:newButton("testBtn", 1, 3, "Test notify", colors.lightBlue, function()
    os.notify("Test", "Hello!")
end)
mainLayout:newLabel("appNameLabel", 1, 1, "", colors.white, colors.gray)
threading.start(term.native(), mainLayout.mainLoop)
threading.start(notifyWindow, notifyLayout.mainLoop)
threading.run()