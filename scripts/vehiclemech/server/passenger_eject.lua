function EjectFunction( args, player )

	player:EnterVehicle(args.vehicle, VehicleSeat.RooftopStunt)

end

Network:Subscribe("EjectPassenger", EjectFunction)