Network:Subscribe("EasyEnterEnterVehicle", function(args, player)
	if player:GetValue("inextraseat") then return end
	if IsValid(args.vehicle) then
		player:EnterVehicle(args.vehicle, args.seat)
	end
end)