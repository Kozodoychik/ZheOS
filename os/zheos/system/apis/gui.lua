local windows = {}
local buttons = {}
local winnum = 0
local selectBtn = 0
function start(label)
	term.setBackgroundColor(colors.blue)
	term.setTextColor(colors.cyan)
	term.clear()
	term.setCursorPos(1,1)
	term.write(label)
end
function newwin(label, xStart, yStart, width, height)
	local win = window.create(term.current(), xStart, yStart, width, height)
	windows[winnum] = win
	term.redirect(win)
	term.setBackgroundColor(colors.white)
	term.setTextColor(colors.black)
	term.clear()
	term.setCursorPos(2,1)
	term.write(label)
	return win
end
function label(win, label, xPos, yPos)
	term.redirect(win)
	term.setCursorPos(xPos, yPos)
	term.write(label)
end
function button(win, label, func)
	local btn = {}
	btn.label = label
	btn.win = win
	btn.onClick = func
	table.insert(buttons, btn)
	term.redirect(win)
	local w, h = term.getSize()
	term.setCursorPos(2, h-2)
	term.setTextColor(colors.white)
	term.setBackgroundColor(colors.blue)
	term.write(" "..label.." ")
end
function mainloop()

end