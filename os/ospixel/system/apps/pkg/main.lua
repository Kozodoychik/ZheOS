os.loadAPI("/ospixel/system/apis/registry.lua")
local args = {...}
if args[1] == "install" then
    print("Installing package: "..args[2])
    local req = http.get("http://kotetube.7m.pl/ospixel/pkgs/"..args[2].."/filesToDownload")
    local files = req.readAll()
	for value in string.gmatch(files, "%S+") do
    	local text = http.get("http://kotetube.7m.pl/ospixel/pkgs/"..args[2].."/"..value)
        if args[3] == nil then
            fs.makeDir('/ospixel/system/apps/pkg')
    	    local file = fs.open("/ospixel/users/"..registry.readKey("user","username").."/apps/"..args[2].."/"..value,'w')
    	    file.write(text.readAll())
            text.close()
    	    file.close()
        else
    	    local file = fs.open(args[3].."/"..value,'w')
    	    file.write(text.readAll())
            text.close()
    	    file.close()
        end
    end
    print("Done!")
elseif args[1] == "uninstall" then
    print("Deleting package: "..args[2])
    fs.delete("/ospixel/user/"..registry.readKey("user","username").."/apps/"..args[3])
end
