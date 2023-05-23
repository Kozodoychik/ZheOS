local args = {...}
if args[1] == nil then
    print("Usages:")
    print("cat <filename>")
else
    local file = fs.open(shell.dir().."/"..args[1],"r")
    local data = file.readAll()
    print(data)
    file.close()
end