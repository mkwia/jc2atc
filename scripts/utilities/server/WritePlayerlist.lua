player_list_timer = Timer()
player_list_delay = 1 -- minutes

function WritePlayerToFile(args)

	if player_list_timer:GetMinutes() > player_list_delay then

		local file = io.open("playerlist.txt", "w")
		for player in Server:GetPlayers() do
			local name = player:GetName()
			file:write(name.."\n".."\n")
		end
		file:flush()
		file:close()

		local file2 = io.open("playercount.txt", "w")
		file2:write(Server:GetPlayerCount())
		file2:flush()
		file2:close()
		
		player_list_timer:Restart()
		
	end
	
end

Events:Subscribe("PreTick", WritePlayerToFile)