local regpath = '.registry'
local registry = {}
local function saveRegistry()
    file = fs.open(regpath, "w")
    file.write(textutils.serialise(registry))
    file.close()
end
local function getKeyFromPath(table, path)
    local node = table
    for v in pairs(path) do
        node = node[v]
        if node == nil then
            error("invalid table path")
            return
        end
    end
    return node
end
local function createKeyFromPath(table, path)
    local node = table
    for v in pairs(path) do
        node = node[v]
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
function createKey(...)
    local path = table.pack(...)
    local key = createKeyFromPath(registry, path)
end
function readKey(...)
    reg = fs.open(regpath..'/'..regname..'/'..keyname, 'r')
    local content = reg.readLine()
    reg.close()
    return content
end
