Network:Subscribe("Muted", function(args)

	local player = args.player

	local time = args.time

	Chat:Broadcast(player.. " has been muted for spamming for "..time.." seconds.", Color.Red)

end)

Network:Subscribe("Unmuted", function(args)

	local player = args.player

	Chat:Broadcast(player.. " has been unmuted.", Color(0, 255, 0))
	
end)