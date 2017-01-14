Events:Subscribe("PlayerChat", function(args)

	if args.text == "/removeallvehicles" then

		for v in Server:GetVehicles() do

			v:Remove()

		end
	
		Chat:Broadcast("Vehicles removed.", Color.Cyan)

	end

end)