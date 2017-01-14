Network:Subscribe("RankRequest", function(args, sender)

	local query = SQL:Query("SELECT * FROM acl_members")
	local result = query:Execute()
	if #result > 0 then
		for _, member in ipairs(result) do

			if tostring(member.steamID) == sender:GetSteamId().string then

				local group = tostring(string.gsub(member.groups, "%A", ""))

				Network:Send(sender, "GroupReceive", group)

			end

		end

	end

end)

Network:Subscribe("RequestTable", function(args, sender)

	for line in io.lines("changelog.txt") do

		local item = string.split(line, "|")

		if item[1] and item[2] and item[3] then

			Network:Send(sender, "ChangelogEntry", item)

		end

	end

end)