local config = textutils.unserialize(fs.open("/zhestartup.cfg","r").readAll())
settings.load("/.systemSettings")
term.clear()
term.setBackgroundColor(colors.black)
term.setCursorPos(1,1)
local inBootMenu = false
local i = 0
local mountPoints = {}
local mountRootPoint = ""
local fsOpen = _G['fs']['open']
local fsDelete = _G['fs']['delete']
local fsMove = _G['fs']['move']
local fsMakeDir = _G['fs']['makeDir']
local fsCopy = _G['fs']['copy']
local fsList = _G['fs']['list']
local fsIsDir = _G['fs']['isDir']
local fsExists = _G['fs']['exists']
local fsFind = _G['fs']['find']
local shellResolve = shell.resolve
local shellResolveProgram = shell.resolveProgram

_G['fs']['list'] = function(path)
    --path = shell.resolve(path)
    local point = nil
    local dir = nil
    if path.sub(path, 1, 3) == "rom" then
        return fsList(path)
    end
    for k,v in pairs(mountPoints) do
        if path.sub(path, 1, string.len(v)) == v then
            point = k
            dir = v
            return fsList(path:gsub(dir, point))
        end
    end
    if not point then
        return fsList(mountRootPoint.."/"..path)
    end
    return fsList(mountRootPoint.."/"..path:gsub(dir, point))
end
_G['fs']['isDir'] = function(path)
    --path = shell.resolve(path)
    if path.sub(path,1,2) == ".." then
        return false
    end
    if path.sub(path, 1, 3) == "rom" then
        return fsIsDir(path)
    end
    local point = nil
    local dir = ""
    for k,v in pairs(mountPoints) do
        if path.sub(path, 1, string.len(v)) == v then
            point = k
            dir = v
            return fsIsDir(path:gsub(dir, point))
        end
    end
    if not point then
        return fsIsDir(mountRootPoint.."/"..path)
    end
    if dir == path then
        return true
    end
    
    return fsIsDir(mountRootPoint.."/"..path:gsub(dir, point))
end
_G['fs']['exists'] = function(path)
    --path = shell.resolve(path)
    local point = nil
    local dir = nil
    if path.sub(path, 1, 3) == "rom" then
        return fsExists(path)
    end
    for k,v in pairs(mountPoints) do
        if path.sub(path, 1, string.len(v)) == v then
            point = k
            dir = v
            return fsExists(path:gsub(dir, point))
        end
    end
    if not point then
        return fsExists(mountRootPoint.."/"..path)
    end
    
    return fsExists(mountRootPoint.."/"..path:gsub(dir, point))
end
_G['fs']['open'] = function(path, mode)
    --path = shell.resolve(path)
    local point = ""
    local dir = nil
    if path.sub(path, 1, 3) == "rom" then
        return fsOpen(path, mode)
    end
    for k,v in pairs(mountPoints) do
        if path.sub(path, 1, string.len(v)) == v then
            point = k
            dir = v
            return fsOpen(path:gsub(dir, point), mode)
        end
    end
    if point == "" then
        return fsOpen(mountRootPoint.."/"..path, mode)
    end
    
    return fsOpen(mountRootPoint.."/"..path:gsub(dir, point), mode)
end
_G['fs']['move'] = function(path, to)
    --path = shell.resolve(path)
    local point = ""
    local dir = nil
    for k,v in pairs(mountPoints) do
        if path.sub(path, 1, string.len(v)) == v then
            point = k
            dir = v
            return fsMove(path:gsub(dir, point), to)
        end
    end
    if point == "" then
        return fsMove(mountRootPoint.."/"..path, to)
    end
    
    return fsMove(mountRootPoint.."/"..path:gsub(dir, point), to)
end

_G['fs']['makeDir'] = function(path)
    --path = shell.resolve(path)
    local point = ""
    local dir = nil
    for k,v in pairs(mountPoints) do
        if path.sub(path, 1, string.len(v)) == v then
            point = k
            dir = v
            return fsMakeDir(path:gsub(dir, point))
        end
    end
    if point == "" then
        return fsMakeDir(mountRootPoint.."/"..path)
    end
    
    return fsMakeDir(mountRootPoint.."/"..path:gsub(dir, point))
end

_G['fs']['find'] = function(path)
    --path = shell.resolve(path)
    local point = ""
    local dir = nil
    for k,v in pairs(mountPoints) do
        if path.sub(path, 1, string.len(v)) == v then
            point = k
            dir = v
            return fsFind(path:gsub(dir, point))
        end
    end
    if point == "" then
        return fsFind(mountRootPoint.."/"..path)
    end
    
    return fsFind(mountRootPoint.."/"..path:gsub(dir, point))
end


_G['mounter'] = {}
_G['mounter']['mount'] = function(from, to)
    if not fsIsDir(from) then
        error("Mount: "..from.." not a directory")
        return nil
    end
    if mountPoints[from] then
        error("Mount: "..from.." is already mounted")
        return nil
    end
    mountPoints[shell.resolve(from)] = shell.resolve(to)
    return nil
end

_G['mounter']['mountRoot'] = function(from)
    if not fsIsDir(from) then
        error("Mount: "..from.." not a directory")
        return nil
    end
    mountRootPoint = from
    return nil
end

_G['mounter']['umount'] = function(point)
    for k,v in pairs(mountPoints) do
        if v == point then
            mountPoints[k] = nil
            return nil
        end
    end
    error("Umount: "..point.."is not mounted")
end

_G['mounter']['getMountPoints'] = function()
    return mountPoints
end

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
    if config.labels[bootTo] == "CraftOS" then
        shell.run("/rom/programs/shell.lua")
    end
    print('mounting system...')
    mounter.mountRoot(config.loadPaths[bootTo])
    mounter.mount(config.loadPaths[bootTo].."/rom","rom")
    mounter.mount("zheos/user","user")
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
    print('mounting system...')
    mounter.mountRoot(config.loadPaths[config.default])
    mounter.mount("zheos/system/rom","rom")
    mounter.mount("zheos/user","user")
    shell.run("init.lua")
end
local ok = pcall(init)
if not ok then
   os.reboot() 
end