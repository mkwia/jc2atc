function startEffect(data)
	Network:Broadcast("startEffect", data)
end
function endEffect(data)
	Network:Broadcast("endEffect", data)
end

Network:Subscribe("startEffect", startEffect)
Network:Subscribe("endEffect", endEffect)
Chat:Broadcast("Smoke Reloaded", Color(0, 255, 255))