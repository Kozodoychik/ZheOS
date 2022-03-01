os.loadAPI("/gkos/system/apis/registry.lua")
local args = {...}
if args[1] == "install" then
    if args[4] ~= "silent" then
    	print("Installing package: "..args[2])
    end
    local req = http.get("http://kotetube.7m.pl/gkos/pkgs/"..args[2].."/info.cfg")
    local files = textutils.unserialise(req.readAll()).files
	for key, value in files do
    	local text = http.get("http://kotetube.7m.pl/gkos/pkgs/"..args[2].."/"..value)
        if args[3] == nil then
            fs.makeDir('/gkos/system/apps/pkg')
    	    local file = fs.open("/gkos/user/"..registry.readKey("user","username").."/apps/"..args[2].."/"..value,'w')
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
    if args[4] ~= "silent" then
    	print("Done!")
    end
elseif args[1] == "uninstall" then
    if args[3] ~= "silent" then
    	print("Deleting package: "..args[2])
    end
    fs.delete("/gkos/user/"..registry.readKey("user","username").."/apps/"..args[3])
end
