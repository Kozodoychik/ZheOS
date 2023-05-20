local buttons = {}
local labels = {}
local texts = {}
local progressBars = {}
local currentText = nil
local bgColor = colors.black

local function focusOnText(id)
	local text = texts[id]
	term.setCursorPos(text.x+#text.text, text.y)
	if #text.text < text.width then
		term.setCursorBlink(true)
	end
end

function redraw()
	term.setBackgroundColor(bgColor)
	term.clear()
	
	for k,v in pairs(buttons) do
		term.setCursorPos(v.x, v.y)
		term.setTextColor(colors.white)
		term.setBackgroundColor(v.bg)
		term.write(" "..v.label.." ")
	end

	term.setBackgroundColor(bgColor)
	
	for k,v in pairs(labels) do
		term.setCursorPos(v.x, v.y)
		term.setTextColor(v.fg)
		term.write(v.text)
	end

	term.setBackgroundColor(colors.gray)

	for k,v in pairs(texts) do
		term.setCursorPos(v.x, v.y)
		term.setTextColor(colors.black)
		term.write(string.rep(" ", v.width))
		term.setCursorPos(v.x, v.y)
		term.write(v.text)
	end

	term.setBackgroundColor(bgColor)

	for k,v in pairs(progressBars) do
		local filled = (v.width/100)*v.progress
		local empty = (v.width)-filled
		term.setCursorPos(v.x, v.y)
		term.setBackgroundColor(v.fg)
		term.write(string.rep(" ", filled))
		term.setBackgroundColor(v.bg)
		term.write(string.rep(" ", empty))
	end
end

function init()
	term.setCursorBlink(false)
	redraw()
end

function exit()
	os.queueEvent("stopGUI")
end

function setBGColor(color)
	bgColor = color
end

function newButton(id, x, y, label, bg, handler)
	local btn = {
		x=x,
		y=y,
		width=#label+2,
		label=label,
		bg=bg,
		handler=handler
	}
	if buttons[id] == nil then
		buttons[id] = btn
	else
		error(id.." button already exists")
	end
end

function newLabel(id, x, y, text, fg)
	local label = {
		x=x,
		y=y,
		fg=fg,
		text=text
	}
	if labels[id] == nil then
		labels[id] = label
	else
		error(id.." label already exists")
	end
end

function newText(id, x, y, width)
	local text = {
		x=x,
		y=y,
		text="",
		width=width
	}
	if texts[id] == nil then
		texts[id] = text
	else
		error(id.." text field already exists")
	end
end

function newProgressBar(id, x, y, width, fg, bg, progress)
	local progress = {
		x=x,
		y=y,
		width=width,
		fg=fg,
		bg=bg,
		progress=progress
	}
	if progressBars[id] == nil then
		progressBars[id] = progress
	else
		error(id.." progressbar already exists")
	end
end

function getButtonProperty(id, prop)
	return buttons[id][prop]
end

function getLabelProperty(id, prop)
	return labels[id][prop]
end

function setButtonProperty(id, prop, value)
	if prop == "label" then
		buttons[id].width = #value+2
	end
	buttons[id][prop] = value
end

function setLabelProperty(id, prop, value)
	labels[id][prop] = value
end

function getTextProperty(id, prop)
	return texts[id][prop]
end

function setTextProperty(id, prop, value)
	texts[id][prop] = value
end

function getProgressProperty(id, prop)
	return progressBars[id][prop]
end

function setProgressProperty(id, prop, value)
	progressBars[id][prop] = value
end

function destroyButton(id)
	buttons[id] = nil
end

function destroyLabel(id)
	labels[id] = nil
end

function destroyText(id)
	texts[id] = nil
end

function destroyProgress(id)
	progressBars[id] = nil
end

function mainLoop()
	while true do
		redraw()
		if currentText then
			focusOnText(currentText)
		end
		local event, p1, p2, p3 = os.pullEvent()
		if event == "stopGUI" then
			term.setBackgroundColor(colors.black)
			term.setTextColor(colors.white)
			term.setCursorPos(1,1)
			term.clear()
			term.setCursorBlink(true)
			return
		elseif event == "mouse_click" then
			if p1 == 1 then
				for k,v in pairs(buttons) do
					if p3 == v.y and p2 >= v.x and p2 < (v.x+v.width) then
						v.handler()
						break
					end 
				end
				for k,v in pairs(texts) do
					if p3 == v.y and p2 >= v.x and p2 < (v.x+v.width) then
						currentText = k
						focusOnText(k)
						break
					else
						term.setCursorBlink(false)
						currentText = nil
					end
				end
			end
		elseif event == "char" then
			if currentText then
				if #texts[currentText].text < texts[currentText].width-1 then
 					texts[currentText].text = texts[currentText].text..p1
				end
			end
		elseif event == "key" then
			if p1 == keys.backspace and currentText then
				if #texts[currentText].text > 0 then
					texts[currentText].text = string.sub(texts[currentText].text, 0, #texts[currentText].text-1)
				end
			end
		end
	end
end