towers = {

maintower = {
pos = Vector3(-6757.519043, 337.996887, -3717.340576),
rad = 8.4},

r2tower = {
pos = Vector3(-6494.007569, 217.965866, -3148.610840),
rad = 5.761892},

r1tower1 = {
pos = Vector3(-6578.255371, 217.26535, -2937.3790285),
rad = 5.761892},

r1tower2 = {
pos = Vector3(-6933.5478515, 217.0299685, -3033.4685055),
rad = 5.761892}

	}

Network:Subscribe("Door", function(args)

	args.player:SetPosition(args.door)

end)

Events:Subscribe("PlayerChat", function(args)

	local ppos = args.player:GetPosition()

	for _, t in pairs(towers) do

		if ppos:Distance(t.pos) < t.rad then

			local dont_change = false

			local query = SQL:Query("SELECT * FROM acl_members")
			local result = query:Execute()
			if #result > 0 then

				for _, member in ipairs(result) do

					if tostring(args.player:GetSteamId()) == tostring(member.steamID) then

						dont_change = true

					end

				end

			end

			if not dont_change then

				local query = SQL:Query("SELECT * FROM donators")
				local result = query:Execute()
				if #result > 0 then

					for _, member in ipairs(result) do

						if tostring(args.player:GetSteamId()) == tostring(member.steam_id) then

							dont_change = true

						end

					end

				end

			end

			if not args.player:GetValue("SteamGroupMember") then

				dont_change = true

				Chat:Send(args.player, "You need to be a member of our steam group to be ATC! ", Color.Cyan, "(JC2ATC)", Color.White)

			end

			if not dont_change and args.text:sub(1, 1) ~= "/" then

				Chat:Broadcast("[ATC] ", Color.Cyan, args.player:GetName(), args.player:GetColor(), ": "..args.text, Color.White)

				return false

			end

		end

	end

end)