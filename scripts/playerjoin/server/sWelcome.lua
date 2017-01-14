args2 = {playtime = nil, kills = nil, deaths = nil}
joined = false

Events:Subscribe("PlayerJoin", function(args)
	local query = SQL:Query("SELECT money, kills, deaths, playtime FROM players WHERE steam_id = ? LIMIT 1")
	query:Bind(1, args.player:GetSteamId().string)
	local result = query:Execute()

	if result[1] then

		pt = tonumber(result[1].playtime)
		k = tonumber(result[1].kills)
		d = tonumber(result[1].deaths)

		args2 = {playtime = pt, kills = k, deaths = d}

		joined = true

	end

end)

Network:Subscribe("ClientLoaded", function(args, sender)

	if joined then

		Network:Send(sender, "onPlayerJoin", args2)

	end

end)