Events:Subscribe("LocalPlayerEjectVehicle", function()

	if LocalPlayer:InVehicle() then

		if LocalPlayer:GetVehicle():GetPosition().y < 201 then

			if LocalPlayer:GetVehicle():GetModelId() == 18 then

				LocalPlayer:SetOxygen(1)

				return false

			end

		end

	end

end)