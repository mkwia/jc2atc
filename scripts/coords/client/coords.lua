Events:Subscribe("LocalPlayerChat", function(args)

	if args.text == "/gat" then

		local at = LocalPlayer:GetAimTarget().position

		Chat:Print(at.x..", "..at.y..", "..at.z, Color.White)

	end

end)