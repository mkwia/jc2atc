player_reply = {}

Events:Subscribe("PlayerChat", function(args)

	local words = string.split(args.text, " ")

	if words[1] == "/msg" or words[1] == "/pm" then

		if #words > 1 and Player.Match(words[2])[1] then

			if #words == 2 then Chat:Send(args.player, "You need to include a message!", Color.Red) return false end

			Chat:Send(Player.Match(words[2])[1], "[PM] ", Color.Red, tostring(args.player), args.player:GetColor(), ": "..string.gsub(args.text, words[1].." "..words[2].." ", ""), Color.White)

			Chat:Send(args.player, "[PM] ", Color.Red, "Message sent to ", Color.White, tostring(Player.Match(words[2])[1]), Player.Match(words[2])[1]:GetColor(), ".", Color.White)

			player_reply[tostring(Player.Match(words[2])[1]:GetId())] = tostring(args.player:GetId())

		else

			Chat:Send(args.player, "You message has no valid recipient!", Color.Red)

		end

		return false

	elseif words[1] == "/reply" then

			if #words == 1 then Chat:Send(args.player, "You need to include a message!", Color.Red) return false end

		if string.match(tostring(player_reply[tostring(args.player:GetId())]), "%d") or string.match(tostring(player_reply[tostring(args.player:GetId())]), "%d%d") then

			Chat:Send(Player.GetById(tonumber(player_reply[tostring(args.player:GetId())])), "[PM] ", Color.Red, tostring(args.player), args.player:GetColor(), ": "..string.gsub(args.text, words[1].." ", ""), Color.White)

			Chat:Send(args.player, "[PM] ", Color.Red, "Message sent to ", Color.White, tostring(Player.GetById(tonumber(player_reply[tostring(args.player:GetId())]))), Player.GetById(tonumber(player_reply[tostring(args.player:GetId())])):GetColor(), ".", Color.White)

			player_reply[tostring(player_reply[tostring(args.player:GetId())])] = tostring(args.player:GetId())

		else

			Chat:Send(args.player, "You have no valid player to reply to!", Color.Red)

		end

		return false

	end

end)

Events:Subscribe("PlayerQuit", function(args)

	player_reply[tostring(args.player:GetId())] = nil

end)