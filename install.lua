local filesToDownload = {"startup.lua","ospixel/logo.nfp","ospixel/system/init.lua"}
function download(filename)
	local req = http.get("https://raw.githubusercontent.com/Kozodoychik/ospixel/1.0.0/os/"..filename)
	local file = fs.open("/"..filename,"w")
	file.write(req.readAll())
	file.close()
end
term.setBackgroundColor(1)
term.setTextColor(128)
term.clear()
term.setCursorPos(15,8)
term.write("OSPixel v1.0.0 Setup")
term.setCursorPos(15,10)
for key, value in ipairs(filesToDownload) do
	term.clearLine()
	term.setCursorPos(15,10)
	term.write(value)
	download(value)
end
term.clearLine()
term.setCursorPos(15,10)
term.write("Done! Press any key to reboot")
os.pullEvent("key")
os.reboot()
