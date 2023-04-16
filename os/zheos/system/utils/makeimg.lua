local args = {...}
local img = {}
local silent = false
for _, v in ipairs(args) do
    if v == "--silent" or v == "-s" then
        silent = true
    end
end
loadFolder = function(img, path)
    local files = fs.list(path)
    for k,v in ipairs(files) do
        if not silent then
            print("Loading "..v)
        end
        img[v] = {isDir=false,content={}}
        if fs.isDir(path.."/"..v) then
            img[v].isDir = true
            img[v].content = loadFolder(img[v].content, path.."/"..v)
        else
            local file = fs.open(path.."/"..v,"rb")
            img[v].content = file.read(fs.getSize(path.."/"..v))
            file.close()          
        end
    end
    return img
end
if args[1] == nil then
    print("Usages:")
    print("makeimg <filename>")
else
    loadFolder(img, shell.resolve(args[1]))
    local outputFile = fs.open("image.img","w")
    outputFile.write(textutils.serialize(img))
    outputFile.close()
end