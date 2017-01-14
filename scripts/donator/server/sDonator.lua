SQL:Execute("CREATE TABLE IF NOT EXISTS donators (steam_id VARCHAR UNIQUE, name VARCHAR, tag VARCHAR, color1 INTEGER, color2 INTEGER, color3 INTEGER)")

donators = {}

local query = SQL:Query("SELECT * FROM donators")
    		local result = query:Execute()
    		if #result > 0 then

    			for _, p in ipairs(result) do

    				table.insert(donators, p)

    			end

    		end

Events:Subscribe("PlayerChat", function(args)

	local words = args.text:split(" ")

	if words[1] ~= "/donator" then return end

	local query = SQL:Query("SELECT * FROM acl_members")
	local result = query:Execute()
	if #result > 0 then
		for _, member in ipairs(result) do

			if tostring(member.steamID) == tostring(args.player:GetSteamId()) then

				local group = tostring(string.gsub(member.groups, "%A", ""))

				if group ~= "Admin" and group ~= "Owner" and group ~= "Developer" then return end

				if words[2] == "list" then

					Chat:Send(args.player, "Donators:", Color.Cyan)

					local count = 0

					local query = SQL:Query("SELECT steam_id, name, tag, color1, color2, color3 FROM donators")
					local result = query:Execute()

					for i, p in ipairs(result) do

						if result[i] ~= nil then

							Chat:Send(args.player, result[i].name..", tag:"..result[i].tag..", Color("..result[i].color1..", "..result[i].color2..", "..result[i].color3..")", Color.White)

							count = count + 1

						end

					end

					if count == 0 then

						Chat:Send(args.player, "None", Color.White)

					end

				return end

				if not words[2] then Chat:Send(args.player, "/donator list/add/remove", Color.White) return end

				if not words[3] then Chat:Send(args.player, "Specify a name!", Color.White) return end

				if words[2] == "add" then

					local player = Player.Match(words[3])[1]
					local id = player:GetSteamId().string
					local name = player:GetName()
					local tag = "Donator"
					local color1 = 255
					local color2 = 0
					local color3 = 255

					local command = SQL:Command("INSERT OR IGNORE INTO donators (steam_id, name, tag, color1, color2, color3) VALUES (?, ?, ?, ?, ?, ?)")
					command:Bind(1, id)
					command:Bind(2, name)
					command:Bind(3, tag)
					command:Bind(4, color1)
					command:Bind(5, color2)
					command:Bind(6, color3)
					command:Execute()

					Chat:Send(args.player, "Added "..name.." to list of donators.", Color.White)

				elseif words[2] == "colour" then

					if not words[6] then Chat:Send(args.player, "Specify: name colour1 colour2 colour3", Color.White) return end

					local command = SQL:Command("UPDATE donators SET color1 = ?, color2 = ?, color3 = ? WHERE steam_id = ?")
					command:Bind(1, words[4])
					command:Bind(2, words[5])
					command:Bind(3, words[6])
					command:Bind(4, Player.Match(words[3])[1]:GetSteamId().string)
					command:Execute()

					Chat:Send(args.player, Player.Match(words[3])[1]:GetName().."'s colour was set to: "..words[4]..", "..words[5]..", "..words[6], Color.White)

				elseif words[2] == "tag" then

					if not words[4] then Chat:Send(args.player, "Specify: name tag", Color.White) return end

					local command = SQL:Command("UPDATE donators SET tag = ? WHERE steam_id = ?")
					command:Bind(1, words[4])
					command:Bind(2, Player.Match(words[3])[1]:GetSteamId().string)
					command:Execute()

					Chat:Send(args.player, Player.Match(words[3])[1]:GetName().."'s tag was set to: "..words[4], Color.White)

				elseif words[2] == "remove" then

					local player = Player.Match(words[3])[1]
					local id = player:GetSteamId().string

					local command = SQL:Command("DELETE FROM donators WHERE steam_id = ?")
					command:Bind(1, id)
					command:Execute()

					Chat:Send(args.player, "Removed "..player:GetName().." from list of donators.", Color.White)

				end

				donators = {}

				local query = SQL:Query("SELECT * FROM donators")
    				local result = query:Execute()
    				if #result > 0 then

    					for _, p in ipairs(result) do

    						table.insert(donators, p)

    					end

    				end

    			Chat:Send(args.player, "List refreshed!", Color.White)

			end

		end

	end

end)

Events:Subscribe("PlayerChat", function(args)

	if args.text:sub(1, 1) == "/" then return end

	local query = SQL:Query("SELECT * FROM acl_members")
	local result = query:Execute()
	if #result > 0 then
		for _, member in ipairs(result) do

			if tostring(member.steamID) == tostring(args.player:GetSteamId()) then return end

		end

	end

	for _, p in ipairs(donators) do

		if p.steam_id == tostring(args.player:GetSteamId()) then

			local color = Color(tonumber(p.color1), tonumber(p.color2), tonumber(p.color3))

    		Chat:Broadcast("["..p.tag.."] ", color, args.player:GetName(), args.player:GetColor(), ": "..args.text, Color.White)

    		return false

    	end

    end

end)
