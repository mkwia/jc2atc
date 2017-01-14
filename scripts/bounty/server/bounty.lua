reset_timer = Timer()
bounty = {}

Events:Subscribe("PlayerChat", function(args)

	local words = string.split(args.text, " ")

	if args.text == "/resetallbountiespls" then

		bounty = {}
		for p in Server:GetPlayers() do updatenetworkvalue(p) end

	return false end

	if words[1] == "/paybounty" then

		if bounty[args.player:GetSteamId().string] ~= nil then

			if args.player:GetMoney() >= bounty[args.player:GetSteamId().string].amount * 5 then

				local amount = bounty[args.player:GetSteamId().string].amount
				args.player:SetMoney(args.player:GetMoney() - amount * 5)
				bounty[args.player:GetSteamId().string] = nil
				updatenetworkvalue(args.player)

				for p in Server:GetPlayers() do

					if p ~= args.player then

						Chat:Send(p, tostring(args.player), args.player:GetColor(), " paid off his bounty for ", Color.White, "£"..tostring(amount * 5), Color.Red, ".", Color.White)

					end

				end

				Chat:Send(args.player, "You have paid off your bounty for £"..tostring(amount * 5)..".", Color.Lime)

			else

				Chat:Send(args.player, "You don't have that much money.", Color.Red)

			end

		else

			Chat:Send(args.player, "You don't have a bounty.", Color.Red)

		end

	elseif words[1] == "/bounty" then

		if #words > 2 then

			if Player.Match(words[2])[1] then

				if tostring(Player.Match(words[2])[1]) ~= tostring(args.player) then

					if string.find(words[3], "[^0-9]") then Chat:Send(args.player, "Syntax: /bounty playername ", Color.White, "amount", Color.Red) return false end

					local victim = Player.Match(words[2])[1]
					local amount = math.floor(tonumber(words[3]))
					local tab = {}

					if amount < 100 then Chat:Send(args.player, "Use a value higher than £100.", Color.Red) return false end

					if amount > args.player:GetMoney() then Chat:Send(args.player, "You don't have that much money.", Color.Red) return false end

					args.player:SetMoney(args.player:GetMoney() - amount)

					for p in Server:GetPlayers() do

						if p ~= victim then

							Chat:Send(p, "Bounty set on ", Color.White, tostring(victim), victim:GetColor(), " by ", Color.White, tostring(args.player), args.player:GetColor(), " for ", Color.White, "£"..tostring(amount), Color.Red, ".", Color.White)

						end

					end

					Chat:Send(victim, "A bounty has been set on your head, you'd better run!", Color.Red)
					if amount > 10000 then
						heat = 3
					elseif amount > 1000 then
						heat = 2
					else
						heat = 1
					end

					if bounty[victim:GetSteamId().string] ~= nil then

						bounty[victim:GetSteamId().string].amount = bounty[victim:GetSteamId().string].amount + amount

					else

						bounty[victim:GetSteamId().string] = {}
						bounty[victim:GetSteamId().string].amount = amount
						
					end

					bounty[victim:GetSteamId().string].time = 60

					if bounty[victim:GetSteamId().string].bountysetter ~= nil then

						local tab = bounty[victim:GetSteamId().string].bountysetter

						tab[args.player:GetSteamId().string] = true

						bounty[victim:GetSteamId().string].bountysetter = tab

					else

						local tab = {}

						tab[args.player:GetSteamId().string] = true

						bounty[victim:GetSteamId().string].bountysetter = tab

					end

					updatenetworkvalue(victim)

				else

					Chat:Send(args.player, "You can't set a bounty on yourself!", Color.Red)

				end

			else

				Chat:Send(args.player, "Player not found.", Color.Red)

			end

		else

			Chat:Send(args.player, "Syntax: /bounty ", Color.White, "playername", Color.Red, " amount", Color.White)

		end

		return false

	end

end)

Events:Subscribe("PlayerDeath", function(args)

	if args.player and bounty[args.player:GetSteamId().string] ~= nil and args.killer then

		if bounty[args.player:GetSteamId().string].bountysetter[args.killer:GetSteamId().string] then return end

		if args.player == args.killer then return end

		args.killer:SetMoney(args.killer:GetMoney() + bounty[args.player:GetSteamId().string].amount)

		Chat:Send(args.killer, "You have retrieved the bounty placed upon ", Color.White, tostring(args.player), Color.Red, ".", Color.White)

		for p in Server:GetPlayers() do

			if p ~= args.killer then

				Chat:Send(p, tostring(args.killer), Color.Red, " retrieved the bounty on ", Color.White, tostring(args.player), Color.Red, ".", Color.White)

			end

		end

		bounty[args.player:GetSteamId().string] = nil
		updatenetworkvalue(args.player)

	end

end)

Events:Subscribe("PostTick", function()

	if reset_timer:GetMinutes() >= 1 then

		for p in Server:GetPlayers() do

			if bounty[p:GetSteamId().string] ~= nil then

				bounty[p:GetSteamId().string].time = bounty[p:GetSteamId().string].time - 1

				if bounty[p:GetSteamId().string].time <= 0 then

					bounty[p:GetSteamId().string] = nil
					updatenetworkvalue(p)

				end

			end

		end

		reset_timer:Restart()

	end

end)

Events:Subscribe("PlayerJoin", function(args)

	if bounty[args.player:GetSteamId().string] == nil then return end

	updatenetworkvalue(args.player)

end)

function updatenetworkvalue(player)

	if bounty[player:GetSteamId().string] ~= nil then

		player:SetNetworkValue("Bounty", bounty[player:GetSteamId().string].amount)

		Network:Send(player, "wanted_level", heat)

	else

		player:SetNetworkValue("Bounty", nil)

		Network:Send(player, "wanted_level", 0)

	end

end

for p in Server:GetPlayers() do updatenetworkvalue(p) end