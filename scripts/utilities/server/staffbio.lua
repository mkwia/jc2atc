Events:Subscribe("PlayerJoin", function(args)

	local query = SQL:Query("SELECT * FROM acl_members")
			local result = query:Execute()
			if #result > 0 then

				for _, member in ipairs(result) do

					if tostring(args.player:GetSteamId()) == tostring(member.steamID) then

						if tostring(string.gsub(member.groups, "%A", "")) == "Helper" then return end

						Chat:Send(args.player, "For the new website we're getting all of the staff to write a short bio (1 or 2 sentences) about who you are, please prepare one ", Color.White, "ASAP", Color.Red, " and send it to ", Color.White, "tally", Color.Cyan, " or", Color.White, " kiwi", Color.Cyan, ", thanks!", Color.White)

					end
					
				end

			end
end)	