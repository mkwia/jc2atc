invalid_vehicles = {}
function AddVehicle(id)
	invalid_vehicles[id] = true
end
AddVehicle(3)
AddVehicle(14)
AddVehicle(67)

Eject = function(args)
	if args.input == Action.StuntJump then
		-- This runs every time you press the stunt jump button
		if (LocalPlayer:InVehicle()) then
			localVehicle = LocalPlayer:GetVehicle()
			if (localVehicle:GetDriver() ~= LocalPlayer and not invalid_vehicles[localVehicle:GetModelId()]) then
				local args = {}
				args.vehicle = localVehicle
				Network:Send("EjectPassenger", args)
			end
		end
	end
	if args.input == Action.ParachuteOpenClose then
		-- This runs every time you press the Parachute Open button
		if (LocalPlayer:InVehicle()) then
			localVehicle = LocalPlayer:GetVehicle()
			if (localVehicle:GetDriver() ~= LocalPlayer and not invalid_vehicles[localVehicle:GetModelId()]) then
				local args = {}
				args.vehicle = localVehicle
				Network:Send("EjectPassenger", args)
			end
		end
	end
end

Events:Subscribe("LocalPlayerInput", Eject)

--function ModulesLoad()
--	Events:Fire( "HelpAddItem",
--        {
--            name = "Passenger Eject",
--            text = 
--                "You can now enter the stunt position on a vehicle from the " ..
--                "passenger seat!\n\n" ..
--                "Your stunt jump or parachute button will put you on the roof. "
--        } )
--end

--function ModuleUnload()
--    Events:Fire( "HelpRemoveItem",
--        {
--            name = "Passenger Eject"
--        } )
--end

--Events:Subscribe("ModulesLoad", ModulesLoad)
--Events:Subscribe("ModuleUnload", ModuleUnload)