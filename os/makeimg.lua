local args = {...}
local files = fs.list(args[1])
local img = {}
for v in pairs(files) do
    img[v] = {}
end