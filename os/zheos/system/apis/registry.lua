local regpath = '.registry'
local function getKeyFromPath(path)
    local node = _G['reg']
    for k,v in ipairs(path) do
        node = node[v]
        if node == nil then
            error("invalid key path")
            return nil
        end
    end
    return node
end
local function createKeyFromPath(value, path)
    local table2 = {}
    if #path == 1 then
      table2[path[1]] = value
    elseif path[1] ~= nil then
      local v = path[1]
      table2[v] = {}
      table.remove(path,1)
      createKeyFromPath(table2[v], value, path)
    end
    for k,v in pairs(table2) do
        _G['reg'][k] = v
    end
end
function saveRegistry()
    file = fs.open(regpath, "w")
    file.write(textutils.serialise(_G['reg']))
    file.close()
end
function loadRegistry()
    file = fs.open(regpath, "r")
    _G['reg'] = textutils.unserialise(file.readAll())
    file.close()
end
function createRegistry()
    _G['reg'] = {}
    saveRegistry()
end
function createKey(value, ...)
    loadRegistry()
    local path = table.pack(...)
    createKeyFromPath(value, path)
    saveRegistry()
end
function readKey(...)
    loadRegistry()
    local path = table.pack(...)
    local value = getKeyFromPath(path)
    return value
end
