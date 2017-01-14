lights = {}

light = ClientLight.Create{
	position = Vector3(-6756.4, 341.2, -3720.0),
	color = Color(0, 255, 0),
	radius = 10,
	multiplier = 10
}

table.insert(lights, light)

light = ClientLight.Create{
	position = Vector3(-6740.3, 211.8, -3650.6),
	color = Color(0, 255, 0),
	radius = 10,
	multiplier = 10
}

table.insert(lights, light)

lowertower = Vector3(-6740.2, 208.4, -3650.8)
uppertower = Vector3(-6756.4, 338.0, -3719.9)

Events:Subscribe("KeyUp", function(args)

	ppos = LocalPlayer:GetPosition()

	if args.key ~= string.byte("E") then return end

	if ppos:Distance(lowertower) < 2 then

		LocalPlayer:SetBaseState(58)

		args2 = {}
		args2.player = LocalPlayer
		args2.door = uppertower

		Network:Send("Door", args2)

	elseif ppos:Distance(uppertower) < 2 then

		LocalPlayer:SetBaseState(61)

		args2 = {}
		args2.player = LocalPlayer
		args2.door = lowertower

		Network:Send("Door", args2)

	end

end)

Events:Subscribe("ModuleUnload", function()

	for index, light in ipairs(lights) do

		light:Remove()

	end

end)