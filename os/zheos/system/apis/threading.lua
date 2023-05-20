local coroutines = {}
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
				printError("Threading is running")
				break
			end
			if coroutine.status(coroutines[i].cor) == "dead" then
				coroutines[i] = nil
				break
			end
			local currentTerm = term.current()
			term.redirect(coroutines[i].win)
			local ok, msg = coroutine.resume(coroutines[i].cor, table.unpack(event))
			term.redirect(currentTerm)
			if not ok then
				printError("thread error: "..msg)
				break
			end
		end
	end
end