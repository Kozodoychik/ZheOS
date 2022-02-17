local filesToDownload = {"startup.lua","ospixel/logo.nfp","ospixel/system/init"}
function download(filename)
	local req = http.get("https://raw.githubusercontent.com/Kozodoychik/ospixel/1.0.0/os/"..filename)
	fs.open("/"..filename,"w")
	fs.write(req.readAll())
	fs.close()
end
term.setBackgroundColor(colors.white)
term.setTextColor(term.gray)
term.clear()
term.setCursorPos(5,10)
term.write("OSPixel v1.0.0 Setup")
term.setCursorPos(5,12)
while key, value in ipairs(filesToDownload) do
	term.clearLine()
	term.write("Installing: "..value)
	download(value)
end
term.clearLine()
term.write("Done! Press any key to reboot")
os.pullEvent("key")
os.reboot()
