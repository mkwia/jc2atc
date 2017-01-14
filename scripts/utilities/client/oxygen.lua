oxygen = false

Events:Subscribe("LocalPlayerChat", function(args)

	if args.text == "/oxygen" then

		oxygen = not oxygen

		Chat:Print("Oxygen enabled? "..tostring(oxygen), Color.White)

	end

end)

Events:Subscribe("PostTick", function()

	if oxygen then

		LocalPlayer:SetOxygen(1)

	end

end)