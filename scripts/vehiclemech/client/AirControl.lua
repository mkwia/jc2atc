up = VirtualKey.Up
down = VirtualKey.Down
left = VirtualKey.Left
right = VirtualKey.Right



Events:Subscribe("KeyDown", function(args)

	if LocalPlayer:InVehicle() and Vehicle.GetClassByModelId(LocalPlayer:GetVehicle():GetModelId()) == 2 then

		if args.key == up or down or left or right then

			local v = LocalPlayer:GetVehicle()

			local vpos = v:GetPosition()

			local gpos = Physics:Raycast(vpos, Vector3.Down, 0, 5).distance

			if gpos >= 3 then

				local vangv = v:GetAngularVelocity()

				local vang = v:GetAngle()

				if args.key == down and (Angle.Inverse(vang) * vangv).x < 1 then

					v:SetAngularVelocity(vangv + vang * Vector3(2, 0, 0))

				elseif args.key == up and (Angle.Inverse(vang) * vangv).x > -1 then

					v:SetAngularVelocity(vangv + vang * Vector3(-2, 0, 0))

				end

				if args.key == right and (Angle.Inverse(vang) * vangv).z > -1 then

					v:SetAngularVelocity(vangv + vang * Vector3(0, 0, -2))

				elseif args.key == left and (Angle.Inverse(vang) * vangv).z < 1 then

					v:SetAngularVelocity(vangv + vang * Vector3(0, 0, 2))

				end

			end

		end

	end

end)