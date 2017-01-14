reserved_slots = 6 -- Change

placeholder_slots = 1 --Change

kick_message = "Sorry, you've been kicked due to slot reservation. Donate to get a reserved slot! bit.do/jc2atcdonate" -- Change

max_players = Config:GetValue("Server", "MaxPlayers")

reserved_players_online = 0

Events:Subscribe("PlayerJoin", function(args)

	if Server:GetPlayerCount() >= (max_players - placeholder_slots) - reserved_players_online then

		local kickplayer = false

		local query = SQL:Query("SELECT * FROM acl_members")
			local result = query:Execute()
			if #result > 0 then

				for _, member in ipairs (result) do

					if tostring(args.player:GetSteamId()) == tostring(member.steamID) then

						reserved_players_online = reserved_players_online + 1

						if reserved_players_online > reserved_slots then

							reserved_players_online = reserved_slots

						end

						kickplayer = true

					end

				end

			end

		local query = SQL:Query("SELECT * FROM donators")
    		local result = query:Execute()
    		if #result > 0 then

    			for _, member in ipairs(result) do

    				if tostring(args.player:GetSteamId()) == tostring(member.steam_id) then

    					kickplayer = true

    					reserved_players_online = reserved_players_online + 1

    					if reserved_players_online > reserved_slots then

							reserved_players_online = reserved_slots

						end
        
    				end

    			end

				if kickplayer then

					local kicked = false

					for p in Server:GetPlayers() do

						if kicked then return end

						local query = SQL:Query("SELECT * FROM acl_members")
							local result = query:Execute()
								if #result > 0 then
									for _, member in ipairs (result) do
										if kicked then return end
										if tostring(p:GetSteamId()) ~= tostring(member.steamID) then
											local query = SQL:Query("SELECT * FROM donators")
    											local result = query:Execute()
    												if #result > 0 then
    													for _, member in ipairs(result) do
    														if kicked then return end
    														if tostring(args.player:GetSteamId()) ~= tostring(member.steam_id) then

																p:Kick(kick_message)

																print("kicked: "..p:GetName().." due to slot reservation.")
																print("reserved players online: "..tostring(reserved_players_online)..".")

																kicked = true

															end
														end
													end
										end
									end
								end
					end

				end

			end

	end

end)

Events:Subscribe("PlayerQuit", function(args)

	local query = SQL:Query("SELECT * FROM acl_members")
			local result = query:Execute()
			if #result > 0 then

				for _, member in ipairs (result) do

					if tostring(args.player:GetSteamId()) == tostring(member.steamID) then

						reserved_players_online = reserved_players_online - 1

						if reserved_players_online < 0 then

							reserved_players_online = 0

						end

					end

				end

			end

		local query = SQL:Query("SELECT * FROM donators")
    		local result = query:Execute()
    		if #result > 0 then

    			for _, member in ipairs(result) do

    				if tostring(args.player:GetSteamId()) == tostring(member.steam_id) then

    					reserved_players_online = reserved_players_online - 1

    					if reserved_players_online < 0 then

							reserved_players_online = 0

						end
        
    				end

    			end

    		end

end)