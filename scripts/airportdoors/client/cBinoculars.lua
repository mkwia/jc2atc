b = false

nv = false

zoom = 0.01

maxdist = 500

binoculars = Image.Create(AssetLocation.Resource, "Binoculars")

Events:Subscribe("KeyUp", function(args)

	if args.key == string.byte("2") and Game:GetState() == GUIState.Game and not LocalPlayer:InVehicle() then

		b = not b

		zoom = 0.01

		if b then

			Chat:SetEnabled(false)

			Events:Fire("HideInfo")

		else

			Chat:SetEnabled(true)

			Events:Fire("ShowInfo")

		end

	end

end)

Events:Subscribe("KeyDown", function(args)

	if b and Game:GetState() == GUIState.Game then

		if args.key == VirtualKey.Up then

			zoom = zoom + 0.005

		elseif args.key == VirtualKey.Down then

			zoom = zoom - 0.005

		end

	end

end)

Events:Subscribe("LocalPlayerChat", function(args)

	if args.text == "/nv" and b and Game:GetState() == GUIState.Game then

		nv = not nv

	end

end)

Events:Subscribe("MouseScroll", function(args)

	if b and Game:GetState() == GUIState.Game then

		zoom = zoom + (args.delta * 0.005)

	end

end)

Events:Subscribe("Render", function()

	if b and Game:GetState() == GUIState.Game then

		LocalPlayer:SetUpperBodyState(347)

		LocalPlayer:SetLeftArmState(392)

		if nv then

			Render:FillArea(Vector2(0, 0), Render.Size, Color(0, 255, 0, 120))

		else

			Render:FillArea(Vector2(0, 0), Render.Size, Color(158, 225, 247, 20))

		end

		binoculars:Draw(Vector2(0, 0), Render.Size, Vector2(0, 0), Vector2(1, 1))

	end

end)

Events:Subscribe("CalcView", function()

	if b and Game:GetState() == GUIState.Game then

		ray = Physics:Raycast(LocalPlayer:GetBonePosition("ragdoll_Head"), Camera:GetAngle() * Vector3.Forward, 0, maxdist)

		if zoom * maxdist > ray.distance then

			effectivezoom = (ray.distance - 2) / maxdist

		else

			effectivezoom = zoom

		end

		if zoom > 1 then

			zoom = 1

			effectivezoom = 1

		elseif zoom < 0 then

			zoom = 0

			effectivezoom = 0

		end

		local zoomfactor = maxdist * effectivezoom

		Camera:SetPosition(LocalPlayer:GetBonePosition("ragdoll_Head") + (Camera:GetAngle() * Vector3.Forward) * zoomfactor)

	end

end)

Events:Subscribe("InputPoll", function()

	if b and Game:GetState() == GUIState.Game then

		if Input:GetValue(17) > 0 then

			Input:SetValue(17, 0)

		end

		if Input:GetValue(18) > 0 then

			Input:SetValue(18, 0)

		end

	end

end)

Events:Subscribe("LocalPlayerEnterVehicle", function()

	b = false

end)