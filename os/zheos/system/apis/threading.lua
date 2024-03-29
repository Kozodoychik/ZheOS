local coroutines = {}
local function onError()
	return
end
local function onStop()
	return
end
function start(window, ...)
	local threads = table.pack(...)
	local cor = nil
	for i=1,threads.n,1 do
		local thread = threads[i]
		if type(thread) ~= "function" then
			error("thread is not function")
			return nil
		end
		cor = coroutine.create(thread)
		table.insert(coroutines, {cor=cor,win=window})
	end
	return #coroutines
end
function run()
	while true do
		local event = {os.pullEventRaw()}
		for i=1,#coroutines,1 do
			if event[1] == "terminate" then
				onStop()
				break
			end
			if coroutines[i] == nil then
				break
			end
			if coroutine.status(coroutines[i].cor) == "dead" then
				coroutines[i] = nil
				onStop()
				break
			end
			if (event[1] == "mouse_click" or event[1] == "mouse_drag") and coroutines[i].win.getPosition then
				local x,y = coroutines[i].win.getPosition()
				event[3] = event[3] - (x - 1)
				event[4] = event[4] - (y - 1)
			end
			term.redirect(coroutines[i].win)
			local ok, msg, p1, p2, p3 = coroutine.resume(coroutines[i].cor, table.unpack(event))
			if (event[1] == "mouse_click" or event[1] == "mouse_drag") and coroutines[i].win.getPosition then
				local x,y = coroutines[i].win.getPosition()
				event[3] = event[3] + (x - 1)
				event[4] = event[4] + (y - 1)
			end
			term.redirect(term.native())
			if not ok then
				term.redirect(term.native())
				error("thread error: "..msg)
				--coroutines[i] = nil
				--onError()
				os.pullEvent("key")
				break
			end
		end
	end
end
function setUpOnError(func)
	onError = func
end
function setUpOnStop(func)
	onStop = func
end
function stopThread(tID)
	if coroutines[tID] then
		coroutines[tID] = nil
	end
end