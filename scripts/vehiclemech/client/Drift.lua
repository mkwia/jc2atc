function OnInputPoll(args)
	if LocalPlayer:InVehicle() then
		--driftcars = {[21] = true, [35] = true, [55] = true, [78] = true, [91] = true, [2] = true, [58] = true, [56] = true}
		--if driftcars[LocalPlayer:GetVehicle():GetModelId()] then
			if Input:GetValue(Action.Accelerate) ~= 0 and Input:GetValue(Action.Handbrake) ~= 0 and Vector3.LengthSqr(LocalPlayer:GetVehicle():GetLinearVelocity()) < 36 then
				Input:SetValue(Action.Handbrake, 0)
				Input:SetValue(Action.Reverse, Input:GetValue(Action.Accelerate))
			end
		--end
	end
end
Events:Subscribe("InputPoll", OnInputPoll)
