groups = {}

Events:Subscribe("PlayerChat", function(args)

	query = SQL:Query("SELECT * FROM acl_groups")
	result = query:Execute()
	if #result > 0 then
		groups = result
	end

	if args.text:sub(1, 1) == "/" then return end

	local query = SQL:Query("SELECT * FROM acl_members")
    		local result = query:Execute()
    		if #result > 0 then

    			for _, p in ipairs(result) do

    				if p.steamID == args.player:GetSteamId().string then

    					for _, g in ipairs(groups) do

    						if ACL:isObjectInGroup(p.steamID, g.name) then

    							local s, _ = tostring(string.gsub(g.tagColour, "%s", ""))

    							local col = string.split(s, ",")

    							Chat:Broadcast("["..tostring(g.tag).."] "..args.player:GetName()..": "..args.text, Color(tonumber(col[1]), tonumber(col[2]), tonumber(col[3])))

                                print("<"..args.player:GetName()..">: "..args.text)

    						return false end

    					end

    				end

    			end

    		end

end)