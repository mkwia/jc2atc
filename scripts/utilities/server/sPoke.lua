staff_ids = {}

local query = SQL:Query("SELECT * FROM acl_members")
local result = query:Execute()
if #result > 0 then
	for _, member in ipairs (result) do
		table.insert(staff_ids, tostring(member.steamID))
	end
end


function PlayerChat(args)

	local players = {}

	if string.sub(args.text, 1, 1) ~= "/" then
	
		for player in Server:GetPlayers() do

			if string.find(string.lower(args.text), string.lower(player:GetName()), 1, true) ~= nil then
			
				table.insert(players, player)
			
			end
	
		end

	end

	Network:SendToPlayers(players, "Poke")

	if 	string.find(string.lower(args.text), " mod", 1, true) ~= nil or
		string.find(string.lower(args.text), "mod ", 1, true) ~= nil or
		string.find(string.lower(args.text), "admin", 1, true) ~= nil then
		
		local staff = {}
		
		for player in Server:GetPlayers() do
		
			for _,id in ipairs(staff_ids) do

				if id == tostring(player:GetSteamId()) then
				
					table.insert(staff, player)

				end
				
			end
		
		end
		
		Network:SendToPlayers(staff, "StaffPoke")

	end

end

Events:Subscribe("PlayerChat", PlayerChat)