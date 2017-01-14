function chat(args)

	if string.sub(args.text, 1, 6) == "/poll " then
		
		local id = args.player:GetSteamId().string
		local text = args.text
	
		local query = SQL:Query("SELECT steamID FROM acl_members WHERE steamID = ? and (groups = ? or groups = ? or groups = ?)")
		query:Bind ( 1, id )
		query:Bind ( 2, "[".."\"".."Admin".."\"".."]" )
		query:Bind ( 3, "[".."\"".."Owner".."\"".."]" )
		query:Bind ( 4, "[".."\"".."Developer".."\"".."]" )
		local result = query:Execute()
		if #result > 0 then

			no = {}
			yes = {}
			poll_sender = args.player
			local st, en = string.find(text, " ")
			local msg = string.sub(text, en + 1)
			
			Network:Broadcast("poll!", msg)

			poll_timer = Timer()
	
		end
	
	end

end
Events:Subscribe("PlayerChat", chat)

function pollend()
	if poll_timer and poll_timer:GetSeconds() >= 15 then
		Chat:Send(poll_sender, "No:", Color.Red)
		local no_num = 0
		for i, p in pairs(no) do
			Chat:Send(poll_sender, tostring(p), Color.White)
			no_num = tostring(i)
		end
		Chat:Send(poll_sender, "Yes:", Color.Lime)
		local yes_num = 0
		for i, p in pairs(yes) do
			Chat:Send(poll_sender, tostring(p), Color.White)
			yes_num = tostring(i)
		end
		Chat:Send(poll_sender, "Poll results: Yes [", Color.White, yes_num, Color.Lime, "], No [", Color.White, no_num, Color.Red, "].", Color.White)
		poll_timer = nil
		poll_sender = nil
	end
end
Events:Subscribe("PostTick", pollend)

Network:Subscribe("no", function(args) table.insert(no, args.sender) end)
Network:Subscribe("yes", function(args) table.insert(yes, args.sender) end)