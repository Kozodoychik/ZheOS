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
			term.redirect(coroutines[i].win)
			local ok, msg = coroutine.resume(coroutines[i].cor, table.unpack(event))
			--term.redirect(term.native())
			if not ok then
				printError("thread error: "..msg)
				--coroutines[i] = nil
				onError()
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