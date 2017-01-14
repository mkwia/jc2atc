--this part allows people to use the ingame chat to send messages
function chat(args)

	if string.sub(args.text, 1, 6) == "/warn " then
		
		local id = args.player:GetSteamId().string
		local text = args.text
	
		local query = SQL:Query("SELECT steamID FROM acl_members WHERE steamID = ? and (groups = ? or groups = ? or groups = ?)")
		query:Bind ( 1, id )
		query:Bind ( 2, "[".."\"".."Admin".."\"".."]" )
		query:Bind ( 3, "[".."\"".."Owner".."\"".."]" )
		query:Bind ( 4, "[".."\"".."Developer".."\"".."]" )
		local result = query:Execute()
		if #result > 0 then

			local st, en = string.find(text, " ")
			local msg = string.sub(text, en + 1)
			
			Network:Broadcast("alert!", msg)
	
		end
	
	end

end
Events:Subscribe("PlayerChat", chat)

function console(args)

	local warn = ""
	local msg = args.text

	Network:Broadcast("alert!", msg)
	print("Said: '"..msg.."'")

end
Console:Subscribe("warn", console)

function warn(args)

	Network:Broadcast("alert!", args.text)

end
Console:Subscribe("warn", warn)