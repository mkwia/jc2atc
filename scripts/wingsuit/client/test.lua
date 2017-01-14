Events:Subscribe("LocalPlayerChat", function(args)

	if args.text == "/bones" then

		for name, bone in pairs(LocalPlayer:GetBones()) do

			print(name)

		end

		return false

	end

end)

Events:Subscribe("KeyUp", function(args)

	if args.key == string.byte("G") and LocalPlayer:GetSteamId().string == "STEAM_0:1:45324628" then

		LocalPlayer:SetBaseState(6)

	end

end)