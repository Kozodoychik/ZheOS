print("RLE compress/decompress tool")
local args = {...}
if args[1] == nil or args[2] == nil then
    print("Usages:")
    print("rletool compress <filename>")
    print("rletool decompress <filename>")
    return
end
local inFile = fs.open(shell.dir().."/"..args[2], "r")
local outFile = fs.open(shell.dir().."/rletool_"..args[2], "w")
if args[1] == "compress" then
    outFile.write(rle.compress(inFile.readAll()))
elseif args[1] == "decompress" then
    outFile.write(rle.decompress(inFile.readAll()))
end
outFile.close()