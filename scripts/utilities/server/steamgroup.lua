Events:Subscribe("PlayerJoin", function(args)
	args.player:RequestGroupMembership(SteamId("103582791437670663"), function(args2)
		if not args2.success then
			print("Error: Could not retrieve group membership status.")
			return
		end
		if args2.member then
			args.player:SetNetworkValue("SteamGroupMember", true)
			print("Steam Group Member joined.")
		end
	end)
end)