Layout = {}
function Layout:new()
	local gui = {}
	local prop = {}
	prop.buttons = {}
	prop.labels = {}
	prop.texts = {}
	prop.progressBars = {}
	prop.rects = {}
	prop.windows = {}
	prop.currentText = nil
	prop.dontTerminate = false
	prop.bgColor = colors.black

	function prop:focusOnText(id)
		local text = prop.texts[id]
		term.setCursorPos(text.x+#text.text, text.y)
		if #text.text < text.width then
			term.setCursorBlink(true)
		end
	end

	function gui:redraw()
		term.setBackgroundColor(prop.bgColor)
		term.clear()
		
		for k,v in pairs(prop.windows) do
			v.win.redraw()
		end
		term.setCursorBlink(false)
		for k,v in pairs(prop.rects) do
			paintutils.drawFilledBox(v.x, v.y, v.x+v.w, v.y+v.h, v.color)
		end

		for k,v in pairs(prop.buttons) do
			term.setCursorPos(v.x, v.y)
			term.setTextColor(colors.white)
			term.setBackgroundColor(v.bg)
			term.write(" "..v.label.." ")
		end
		
		for k,v in pairs(prop.labels) do
			term.setBackgroundColor(v.bg)
			term.setCursorPos(v.x, v.y)
			term.setTextColor(v.fg)
			term.write(v.text)
		end

		term.setBackgroundColor(colors.gray)

		for k,v in pairs(prop.texts) do
			term.setCursorPos(v.x, v.y)
			term.setTextColor(colors.black)
			term.write(string.rep(" ", v.width))
			term.setCursorPos(v.x, v.y)
			term.write(v.text)
		end

		for k,v in pairs(prop.progressBars) do
			local filled = (v.width/100)*v.progress
			local empty = (v.width)-filled
			term.setCursorPos(v.x, v.y)
			term.setBackgroundColor(v.fg)
			term.write(string.rep(" ", filled))
			term.setBackgroundColor(v.bg)
			term.write(string.rep(" ", empty))
		end
	end

	function gui:init()
		term.setCursorBlink(false)
		gui.redraw()
	end

	function gui:exit()
		os.queueEvent("stopGUI")
	end

	function gui:setBGColor(color)
		prop.bgColor = color
	end

	function gui:newButton(id, x, y, label, bg, handler)
		local btn = {
			x=x,
			y=y,
			width=#label+2,
			label=label,
			bg=bg,
			handler=handler
		}
		if prop.buttons[id] == nil then
			prop.buttons[id] = btn
		else
			error(id.." button already exists")
		end
	end

	function gui:newLabel(id, x, y, text, fg, ...)
		local args = {...}
		local label = {
			x=x,
			y=y,
			fg=fg,
			bg=args[1] or prop.bgColor,
			text=text
		}
		if prop.labels[id] == nil then
			prop.labels[id] = label
		else
			error(id.." label already exists")
		end
	end

	function gui:newText(id, x, y, width)
		local text = {
			x=x,
			y=y,
			text="",
			width=width
		}
		if prop.texts[id] == nil then
			prop.texts[id] = text
		else
			error(id.." text field already exists")
		end
	end

	function gui:newProgressBar(id, x, y, width, fg, bg, progress)
		local progress = {
			x=x,
			y=y,
			width=width,
			fg=fg,
			bg=bg,
			progress=progress
		}
		if prop.progressBars[id] == nil then
			prop.progressBars[id] = progress
		else
			error(id.." progressbar already exists")
		end
	end

	function gui:newRect(id, x, y, width, height, color)
		local rect = {
			x=x,
			y=y,
			w=width,
			h=height,
			color=color
		}
		prop.rects[id] = rect
	end

	function gui:newWindow(id, name, visible)
		local win = {
			name=name,
			win=window.create(term.native(), 1, 2, 51, 17, visible)
		}
		prop.windows[id] = win
		prop.windows[id].win.redraw()
		return prop.windows[id].win
	end

	function gui:getWindowProperty(id, proper)
		return prop.windows[id][proper]
	end

	function gui:setWindowProperty(id, proper, value)
		prop.windows[id][proper] = value
	end

	function gui:getButtonProperty(id, proper)
		return prop.buttons[id][proper]
	end

	function gui:getLabelProperty(id, proper)
		return prop.labels[id][proper]
	end

	function gui:setButtonProperty(id, proper, value)
		if proper == "label" then
			prop.buttons[id].width = #value+2
		end
		prop.buttons[id][proper] = value
	end

	function gui:setLabelProperty(id, proper, value)
		prop.labels[id][proper] = value
	end

	function gui:getTextProperty(id, proper)
		return prop.texts[id][proper]
	end

	function gui:setTextProperty(id, proper, value)
		prop.texts[id][proper] = value
	end

	function gui:getProgressProperty(id, proper)
		return prop.progressBars[id][proper]
	end

	function gui:setProgressProperty(id, proper, value)
		prop.progressBars[id][proper] = value
	end

	function gui:destroyButton(id)
		prop.buttons[id] = nil
	end

	function gui:destroyLabel(id)
		prop.labels[id] = nil
	end

	function gui:destroyText(id)
		prop.texts[id] = nil
	end

	function gui:destroyProgress(id)
		prop.progressBars[id] = nil
	end

	function gui:dontTerminate(bool)
		prop.dontTerminate = bool
	end

	function gui:mainLoop()
		while true do
			gui:redraw()
			if prop.currentText then
				prop:focusOnText(prop.currentText)
			end
			local event, p1, p2, p3 = os.pullEventRaw()
			if event == "stopGUI" or event == "terminate" then
				if not prop.dontTerminate and event == "terminate" then
					prop.buttons = {}
					prop.labels = {}
					prop.texts = {}
					prop.rects = {}
					prop.progressBars = {}
					prop.windows = {}
					term.setBackgroundColor(colors.black)
					term.setTextColor(colors.white)
					term.setCursorPos(1,1)
					term.clear()
					term.setCursorBlink(true)
				end
				return
			elseif event == "mouse_click" then
				if p1 == 1 then
					for k,v in pairs(prop.buttons) do
						if p3 == v.y and p2 >= v.x and p2 < (v.x+v.width) then
							v.handler()
							break
						end 
					end
					for k,v in pairs(prop.texts) do
						if p3 == v.y and p2 >= v.x and p2 < (v.x+v.width) then
							prop.currentText = k
							prop:focusOnText(k)
							break
						else
							term.setCursorBlink(false)
							prop.currentText = nil
						end
					end
				end
			elseif event == "char" then
				if prop.currentText then
					if #prop.texts[prop.currentText].text < prop.texts[prop.currentText].width-1 then
						prop.texts[prop.currentText].text = prop.texts[prop.currentText].text..p1
					end
				end
			elseif event == "key" then
				if p1 == keys.backspace and prop.currentText then
					if #prop.texts[prop.currentText].text > 0 then
						prop.texts[prop.currentText].text = string.sub(prop.texts[prop.currentText].text, 0, #prop.texts[prop.currentText].text-1)
					end
				end
			end
		end
	end
	setmetatable(gui, self)
	self.__index = self;
	return gui
end