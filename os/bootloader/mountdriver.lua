local mountPoints = {zheos="test"}
local fsOpen = _G['fs']['open']
local fsDelete = _G['fs']['delete']
local fsMove = _G['fs']['move']
local fsCopy = _G['fs']['copy']
local fsList = _G['fs']['list']
local fsIsDir = _G['fs']['isDir']
local fsExists = _G['fs']['exists']

fs.list = function(path)
    local point = nil
    for k,v in pairs(mountPoints) do
        if path.sub(path, 1, string.len(k)) then
            point = v
            break
        end
    end
    if not point then
        return fsList(path)
    end
    return fsList(point.."/"..path)
end