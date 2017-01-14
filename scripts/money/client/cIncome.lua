Events:Subscribe("LocalPlayerEnterVehicle", function(args)

	if isInPlane(false) then

		player_timer = Timer()

	end

end)

Events:Subscribe("LocalPlayerExitVehicle", function(args)

	player_timer = nil

end)

Events:Subscribe("PostTick", function()

	if player_timer then

		if player_timer:GetMinutes() >= 1 then

			local money = getPlaneMult(true) * LocalPlayer:GetVehicle():GetHealth() * 10

			Network:Send("AddMoney", money)

			player_timer:Restart()

		end

	end

end)

function isInPlane(checkPassenger)
	if LocalPlayer:GetVehicle() ~= nil then
		if LocalPlayer:GetVehicle():GetDriver() ~= LocalPlayer and checkPassenger == true then
			return false
		end
		if LocalPlayer:GetVehicle():GetName() == "Peek Airhawk 225" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Pell Silverbolt 6" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Cassius 192" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Si-47 Leopard" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "G9 Eclipse" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Aeroliner 474" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "Bering I-86DP" then
			return true
		end
		if LocalPlayer:GetVehicle():GetName() == "F-33 DragonFly" then
			return true
		end
	end
	return false
end

function getPlaneMult(checkPassenger)
	local val = 0
	if LocalPlayer:GetVehicle() ~= nil then
		if LocalPlayer:GetVehicle():GetName() == "Peek Airhawk 225" then
			val = 1
		end
		if LocalPlayer:GetVehicle():GetName() == "Pell Silverbolt 6" then
			val = 1
		end
		if LocalPlayer:GetVehicle():GetName() == "Cassius 192" then
			val = 1.5
		end
		if LocalPlayer:GetVehicle():GetName() == "Si-47 Leopard" then
			val = 1
		end
		if LocalPlayer:GetVehicle():GetName() == "G9 Eclipse" then
			val = 1
		end
		if LocalPlayer:GetVehicle():GetName() == "Aeroliner 474" then
			val = 2
		end
		if LocalPlayer:GetVehicle():GetName() == "Bering I-86DP" then
			val = 2
		end
		if LocalPlayer:GetVehicle():GetName() == "F-33 DragonFly" then
			val = 1
		end
		if LocalPlayer:GetVehicle():GetDriver() ~= LocalPlayer and checkPassenger then
			val = val/2
		end
	end
	return val
end