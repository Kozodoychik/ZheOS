local regpath = '.registry'
local registry = {}
local function saveRegistry()
    file = fs.open(regpath, "w")
    file.write(textutils.serialise(registry))
    file.close()
end
local function getKeyFromPath(table, path)
    local node = table
    for k,v in ipairs(path) do
        node = node[v]
        if node == nil then
            error("invalid key path")
            return nil
        end
    end
    return node
end
local function createKeyFromPath(t, value, path)
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
        t[k] = v
    end
end
function loadRegistry()
    file = fs.open(regpath, "r")
    registry = textutils.unserialise(file.readAll())
    file.close()
end
function createRegistry()
    saveRegistry()
end
function createKey(value, ...)
    local path = table.pack(...)
    createKeyFromPath(registry, value, path)
end
function readKey(...)
    local path = table.pack(...)
    local value = getKeyFromPath(registry, path)
    return value
end
