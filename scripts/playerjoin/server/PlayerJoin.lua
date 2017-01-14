color = Color(255, 165, 0)

function playerJoin(args)
	local ply = args.player
	for p in Server:GetPlayers() do
		if p ~= args.player then
			Network:Send(p, "popup", {text = tostring(ply).." joined the server.", icon = false})
		end
	end
end

function playerLeave(args)
	local ply = args.player
	for p in Server:GetPlayers() do
		if p ~= args.player then
			Network:Send(p, "popup", {text = tostring(ply).." left the server.", icon = false})
		end
	end
end

function playerDie(args)
	local ply = args.player
	for p in Server:GetPlayers() do
		if p ~= args.player then
			if p:GetPosition():Distance(args.player:GetPosition()) < 1000 then
				Network:Send(p, "popup", {text = tostring(ply).." died.", icon = false})
			end
		end
	end
end

Events:Subscribe("PlayerJoin", playerJoin)
Events:Subscribe("PlayerQuit", playerLeave)
Events:Subscribe("PlayerDeath", playerDie)