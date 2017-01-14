--this part allows people to use the ingame chat to send messages
function chat(args)

	local words = string.split(args.text, " ")

	if words[1] == "/bitchslap" then
		
		local id = args.player:GetSteamId().string
		local text = args.text
	
		local query = SQL:Query("SELECT steamID FROM acl_members WHERE steamID = ? and (groups = ? or groups = ? or groups = ?)")
		query:Bind ( 1, id )
		query:Bind ( 2, "[".."\"".."Admin".."\"".."]" )
		query:Bind ( 3, "[".."\"".."Owner".."\"".."]" )
		query:Bind ( 4, "[".."\"".."Developer".."\"".."]" )
		local result = query:Execute()
		if #result > 0 then

			ply = Player.Match(words[2])[1]

			Chat:Broadcast(ply:GetName().." has been bitchslapped!", Color.Red)

			Network:Send(ply, "BitchSlap")

		end

	end

end
Events:Subscribe("PlayerChat", chat)