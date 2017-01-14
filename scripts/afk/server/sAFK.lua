Network:Subscribe("afk", function(args)
	local ply = tostring(args.player)
	if args.afk == true then
		Chat:Broadcast(ply.." is now AFK.", Color.Magenta)
	elseif args.afk == false then
		Chat:Broadcast(ply.." is no longer AFK.", Color.Magenta)
	end
end)