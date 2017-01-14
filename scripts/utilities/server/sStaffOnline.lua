Events:Subscribe("PlayerChat", function(args)
	if args.text == "/staff" then
		Chat:Send(args.player, "Staff Online:", Color.Cyan)
		local staff = {}
		local count = 0
		local query = SQL:Query("SELECT * FROM acl_members")
		local result = query:Execute()
		if #result > 0 then
			for _, member in ipairs (result) do
				for p in Server:GetPlayers() do
					if tostring(p:GetSteamId()) == tostring(member.steamID) then
							count = count + 1
							Chat:Send(args.player, "►", Color.Cyan, p:GetName(), Color.White)
					end
				end
			end
			if count == 0 then
				Chat:Send(args.player, "There are currently no members of staff online... Sorry :/", Color.White)
			end
		end
	return false
	end
end)