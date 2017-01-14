timer = Timer()
ticks = 0
prev_ticks = 100
 
function OnPreTick(args)

	ticks = ticks + 1
	if timer:GetSeconds() > 1 then
		if ticks ~= prev_ticks then
			prev_ticks = ticks
			Network:Broadcast("TPS", ticks)
			Events:Fire("ConsoleReturnTick", ticks)
		end
		timer:Restart()
		ticks = 0
	end
	
end
 
Events:Subscribe("PreTick", OnPreTick)