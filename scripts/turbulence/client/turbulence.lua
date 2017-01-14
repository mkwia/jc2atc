active = true

weather_timer = Timer()
wind_timer = Timer()
change_timer = Timer()

turbulence = 1
max = 0.025 * turbulence
rollmax = max * 1
pitchmax = max * 0.25

winddirection = {
	pitch = 0,
	roll = 0
		}

winddirectionprev = {
	pitch = 1,
	roll = 1
		}

dist = 0
yaw = 0

x = 1
y = 1
z = 1

altitudeoffset = 100

planes = {}
planes[24] = 113 -- F-33 DragonFly
planes[30] = 95 -- Si-47 Leopard
planes[34] = 112 -- G9 Eclipse
planes[39] = 91 -- Aeroliner 474
planes[51] = 87 -- Cassius 192
planes[59] = 68 -- Peek Airhawk 225
planes[81] = 95 -- Pell Silverbolt 6
planes[85] = 95 -- Bering I-86DP

function masscoefficient(mass)
	local r = 0.5 + 3000/mass
	return r
end

function turbulencecoefficient()
	local r = Game:GetWeatherSeverity()
	--if LocalPlayer:GetClimateZone() == 1 or LocalPlayer:GetClimateZone() == 4 then
	--	r = r + 1
	--end

	return r
end

--[[ Ratios
		
		weather sev 2 = 2
		weather sev 1 = 1
		weather sev 0 = 0
		(mountains or sea = +1)
]]

Events:Subscribe("LocalPlayerChat", function(args)

	if args.text == "/turbulence" then

		active = not active

		Chat:Print("Turbulence toggled.", Color.White)

	end

end)

Events:Subscribe("Render", function()

	if not active then return end

	if weather_timer:GetSeconds() >= 10 then
		turbulence = turbulencecoefficient()
		weather_timer:Restart()
	end

	if wind_timer:GetSeconds() >= turbulence * 10 + 1 then

		winddirectionprev.roll = renderpos(math.ceil(math.deg(winddirection.roll)))
		winddirectionprev.pitch = renderpos(math.ceil(math.deg(winddirection.pitch)))

		local winddirectionpitchnew = math.random(0, 1)/10
		local winddirectionpitchneg = math.random(0, 1)
		if winddirectionpitchneg > 0.5 then
			winddirectionpitchnew = winddirectionpitchnew * -1
		end
		winddirection.pitch = winddirection.pitch + winddirectionpitchnew
		if winddirection.pitch > math.pi/2 then winddirection.pitch = math.pi/2 end
		if winddirection.pitch < -math.pi/2 then winddirection.pitch = -math.pi/2 end

		local winddirectionrollnew = math.random(0, 1)/10
		local winddirectionrollneg = math.random(0, 1)
		if winddirectionrollneg > 0.5 then
			winddirectionrollnew = winddirectionrollnew * -1
		end
		winddirection.roll = winddirection.roll + winddirectionrollnew
		if winddirection.roll > math.pi then winddirection.roll = math.pi end
		if winddirection.roll < -math.pi then winddirection.roll = -math.pi end

		wind_timer:Restart()

	end

	if LocalPlayer:GetVehicle() then

		local v = LocalPlayer:GetVehicle()
		local vmodel = v:GetModelId()

		if v:GetDriver() == LocalPlayer and planes[vmodel] then

			max = 0.025 * turbulence
			rollmax = max * 1
			pitchmax = max * 0.25

			local vpos = v:GetPosition()
			local vheight = vpos.y
			dist = ((Physics:Raycast(vpos, Vector3.Down, 0, 1000).distance) + altitudeoffset)/(2000 + altitudeoffset)
			if vheight > 2200 then dist = 0 end
			local mass = Vehicle.GetMassByModelId(vmodel)
			mass = masscoefficient(mass)

			local pitchmath1 = v:GetAngle().yaw + winddirection.pitch
			local pitchmath2 = 1
			local pitchmathneg = pitchmath1
			pitchmath1 = math.abs(pitchmath1)
			if pitchmathneg > 0 then
				pitchmath2 = -1
			else
				pitchmath2 = 1
			end
			local pitch = pitchmath2 * math.sin(pitchmath1)
						
			if pitch > pitchmax then pitch = pitchmax end
			if pitch < -pitchmax then pitch = -pitchmax end

			local rollmath1 = v:GetAngle().yaw + winddirection.roll
			local rollmath2 = 1
			local rollmathneg = rollmath1
			rollmath1 = math.abs(rollmath1)
			if rollmathneg > 0 then
				rollmath2 = -1
			else
				rollmath2 = 1
			end
			local roll = rollmath2 * math.sin(rollmath1)
						
			if roll > rollmax then roll = rollmax end
			if roll < -rollmax then roll = -rollmax end

			local angv = v:GetAngularVelocity()
			local ang = v:GetAngle()
			local rollmult = math.abs(ang.roll)
			if rollmult > math.pi/2 then
				rollmult = -1
			else
				rollmult = 1
			end
			v:SetAngularVelocity(angv + (ang * Vector3(pitch, 0, roll * rollmult)) * dist * mass)

		--[[	if LocalPlayer:GetName() == "tally" then
			local vel = v:GetLinearVelocity()
			local angularcomponent = math.abs(ang.yaw - winddirection.roll)
			local max = planes[vmodel]
			local extra = max * mass/10 * turbulence/2 * dist*2
			if angularcomponent > math.pi/2 then
				print((vel + ang * Vector3.Backward * 5 * math.abs(math.cos(angularcomponent))):Length())
				if vel:Length() > (max - extra) * 5 * math.abs(math.cos(angularcomponent)) then
					v:SetLinearVelocity(vel + ang * Vector3.Backward)
				end
			end
			end]]

			--[[if max and dist and mass and ang then

				local vel = v:GetLinearVelocity()
				x = math.random(0, 0.5) * -(x/x) * max * dist * mass
				y = math.random(0, 0.5) * -(y/y) * max * dist * mass
				z = math.random(0, 0.5) * -(y/y) * max * dist * mass
				v:SetLinearVelocity(vel + Vector3(x, y, z))

				print(x..", "..y..", "..z)

			end]]

			--[[Render:DrawText(Vector2(0.1 * Render.Size.x, 0.475 * Render.Size.y), "winddirection.pitch: "..winddirection.pitch, Color.White)

			Render:DrawText(Vector2(0.1 * Render.Size.x, 0.5 * Render.Size.y), "pitch: "..pitch, Color.White)
			Render:DrawText(Vector2(0.1 * Render.Size.x, 0.525 * Render.Size.y), "roll: "..roll, Color.White)

			Render:DrawText(Vector2(0.1 * Render.Size.x, 0.475 * Render.Size.y), "winddirection.roll: "..math.ceil(math.deg(winddirection.roll)), Color.White)
			Render:DrawText(Vector2(0.1 * Render.Size.x, 0.525 * Render.Size.y), "winddirection.pitch: "..math.ceil(math.deg(winddirection.pitch)), Color.White)]]

		end

			--[[Render:FillCircle(Vector2(0.1 * Render.Size.x, 0.4 * Render.Size.y), 0.05 * Render.Size.x, Color.Lime)

			local arrow = Image.Create(AssetLocation.Resource, "arrow")
			local trans = Transform2()
			trans:Rotate(winddirection.roll)
			Render:SetTransform(trans)
			arrow:SetSize(Vector2(0.015 * Render.Size.x, 0.05 * Render.Size.x))
			arrow:SetPosition(Vector2(0.1 * Render.Size.x - arrow:GetSize().x/2, 0.4 * Render.Size.y))
			arrow:Draw()]]

	end

	if LocalPlayer:GetVehicle() and planes[LocalPlayer:GetVehicle():GetModelId()] then
		prev = winddirectionprev.roll
		local current = renderpos(math.ceil(math.deg(winddirection.roll)))
		if change_timer:GetSeconds() >= 0.5/turbulence then
			if prev < current then
				prev = prev + 1
			elseif prev > current then
				prev = prev - 1
			end
			winddirectionprev.roll = prev
			change_timer:Restart()
		end
		Render:DrawText(Vector2(0.1 * Render.Size.x, 0.45 * Render.Size.y), "Wind Direction: "..prev.."\176", Color.White)
		if dist == 0 then
			Render:DrawText(Vector2(0.1 * Render.Size.x, 0.475 * Render.Size.y), "Wind Speed: "..math.ceil(1 * 1.94384).." knots", Color.White)
		else
			Render:DrawText(Vector2(0.1 * Render.Size.x, 0.475 * Render.Size.y), "Wind Speed: "..math.ceil((turbulence * 6 + math.ceil(dist * 3) + 1) * 1.94384).." knots", Color.White)	
		end	
	end

end)

function renderpos(y)
	if y <= 0 then
		y = 360 + y
	end
	return y	
end