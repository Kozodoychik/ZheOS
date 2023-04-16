local args = {...}
local files = fs.list(args[1])
local img = {}
local loadFolder = function(img, path)
    for k,v in ipairs(files) do
        img[k].isDir = false
        img[k].content = nil
        if fs.isDir(path.."/"..k) then
            img[k].isDir = true
            img[k].content = loadFolder(img[k].content, path.."/"..k)
            
        end
    end
    return img
end
img = loadFolder(img, shell.resolve(args[1]))
local outputFile = fs.open("image.img","w")
outputFile.write(textutils.serialize(img))