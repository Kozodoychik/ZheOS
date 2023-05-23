local regpath = 'zheos/system/.registry'
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
local function createKeyFromPath(t, value, path)
    local node = t    
    for k,v in ipairs(path) do
      if k == #path then
        node[v] = value
        return
      end
      if node[v] == nil then
        node[v] = {}
      end
      node = node[v]
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
    createKeyFromPath(_G['reg'], value, path)
    saveRegistry()
end
function readKey(...)
    loadRegistry()
    local path = table.pack(...)
    local value = getKeyFromPath(path)
    return value
end
