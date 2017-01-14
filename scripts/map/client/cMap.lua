-- Written by Sinister Rectus - http://www.jc-mp.com/forums/index.php?action=profile;u=73431

class 'Map'

function Map:__init()

	self.map_scale = 1
	self.icon_scale = 0.04
	self.text_scale = 0.015
	self.text_size = Render.Height * self.text_scale
	
	self.enabled = true
	
	self.players = {}
	
	self.network_timer = Timer()
	self.network_delay = 1000 -- ms
	
	self.extraction_enabled = true
	self.extraction_speed = 5 -- km/s
	
	self.start_extraction_delay = 2000 -- ms
	self.end_extraction_delay = 2000 -- ms
	self.drop_delay = 2000 -- ms

	self.render = false
	self.labels = 0
	
	self.inputs = {
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[11] = true,
		[12] = true,
		[13] = true,
		[14] = true,
		[17] = true,
		[18] = true,
		[105] = true,
		[137] = true,
		[138] = true,
		[139] = true
	}

	self.airv = {
		--[3] = true,
		--[14] = true,
		[24] = true,
		[30] = true,
		[34] = true,
		--[37] = true,
		[39] = true,
		[51] = true,
		--[57] = true,
		[59] = true,
		--[62] = true,
		--[64] = true,
		--[65] = true,
		--[67] = true,
		[81] = true,
		[85] = true,
	}
	
	self.map = Image.Create(AssetLocation.Game, 'pda_map_dif.dds')
	self.map:SetSize(Vector2(Render.Height, Render.Height) * self.map_scale)
	self.map:SetPosition(Vector2(0.5 * Render.Width - 0.5 * self.map:GetSize().x, 0.5 * Render.Height - 0.5 * self.map:GetSize().y))
	
	self.marker = Image.Create(AssetLocation.Game, "hud_icon_objective_dif.dds")
	self.marker:SetSize(Vector2(1, 1) * Render.Height * self.icon_scale)
	
	self.waypoint = Image.Create(AssetLocation.Game, "hud_icon_waypoint_dif.dds")
	self.waypoint:SetSize(Vector2(1, 1) * Render.Height * self.icon_scale)
	
	self.heli = Image.Create(AssetLocation.Game, "hud_icon_heli_orange_dif.dds")
	self.heli:SetSize(Vector2(1, 1) * Render.Height * self.icon_scale)
	
	Events:Subscribe("MouseUp", self, self.OnMouseUp)
	Events:Subscribe("KeyUp", self, self.ToggleMap)
	Events:Subscribe("PostRender", self, self.OnPostRender)
	Events:Subscribe("ResolutionChange", self, self.OnResolutionChange)
	Events:Subscribe("LocalPlayerInput", self, self.InputBlock)

	Network:Subscribe("PlayerUpdate", self, self.OnPlayerUpdate)
	Network:Subscribe("Toggle", self, self.ToggleMarker)
	Network:Subscribe("ToggleMap", self, self.ToggleMapCMD)

end

function Map:ToggleMap(args)

	if self.enabled then
	
		local k = args.key
		
		if not self.render and k == VirtualKey.F2 and Game:GetState() == GUIState.Game then
			Mouse:SetVisible(true)
			self.render = true
			Events:Fire("HideInfo")
		elseif self.render and (k == VirtualKey.Escape or k == VirtualKey.F1 or k == VirtualKey.F2) and not self.extraction_sequence then
			Mouse:SetVisible(false)
			self.render = false
			Events:Fire("ShowInfo")
		elseif self.render and k == string.byte("1") then
			local waypoint, bool = Waypoint:GetPosition()	
			if bool then
				Waypoint:Remove()
			else 
				Waypoint:SetPosition(self:MapToWorld(Mouse:GetPosition()))	
			end
		end
		
	end

end

function Map:ToggleMapCMD()

	if self.enabled then

		if not self.render and Game:GetState() == GUIState.Game then
			Mouse:SetVisible(true)
			self.render = true
			Events:Fire("HideInfo")
		elseif self.render and not self.extraction_sequence then
			Mouse:SetVisible(false)
			self.render = false
			Events:Fire("ShowInfo")
		end

	end

end

function Map:ToggleMarker(args)

	self.enabled = args
	
	if not self.enabled then
		self.render = false
		Mouse:SetVisible(false)
		Events:Fire("ShowInfo")
	end

end

function Map:OnMouseUp(args)

	if self.enabled and self.render and Game:GetState() == GUIState.Game and not self.extraction_sequence and LocalPlayer:GetValue("Bounty") == nil then
	
		if args.button == 1 then
	
			if not LocalPlayer:InVehicle() then
		
				local position = self:MapToWorld(Mouse:GetPosition())
				
				if position.x >= -16384 and position.x <= 16384 and position.z >= -16384 and position.z <= 16384 then
				
					if self.extraction_enabled then
				
						self.previous_position = LocalPlayer:GetPosition()
						self.next_position = position
						self.extraction_delay = 0.001 * Vector3.Distance(self.previous_position, self.next_position) / self.extraction_speed
						self.extraction_sequence = Events:Subscribe("PreTick", self, self.ExtractionSequence)
						Game:FireEvent("ply.makeinvulnerable")
						self.start_extraction_timer = Timer()
						Mouse:SetVisible(false)
						
					else
					
						Network:Send("InitialTeleport", {position = position})
						
					end

				end
				
			else

				Chat:Print("You can't be extracted when in a vehicle!", Color.Red)

			end
			
		elseif args.button == 3 then
		
			local waypoint, bool = Waypoint:GetPosition()
			
			if bool then
				Waypoint:Remove()
			else 
				Waypoint:SetPosition(self:MapToWorld(Mouse:GetPosition()))	
			end
			
		elseif args.button == 2 then
		
			if self.labels == 2 then
				self.labels = 0
			else
				self.labels = self.labels + 1
			end
				
		end
		
	end

end

function Map:ExtractionSequence()

	if not self.extraction_sequence then return end

	if self.start_extraction_timer then
		
		if self.start_extraction_timer:GetMilliseconds() > self.start_extraction_delay then
		
			Network:Send("InitialTeleport", {position = self.next_position})
			self.start_extraction_timer = nil
			self.extraction_timer = Timer()
			self.teleporting = true
	
		end
		
	end
	
	if self.teleporting then 
	
		if LocalPlayer:GetPosition() ~= self.previous_position then
		
			self.teleporting = false
			self.loading = true
			
		end
		
	end
	
	if self.loading then 
		
		if LocalPlayer:GetLinearVelocity() ~= Vector3.Zero then
		
			self.loading = false
	
		end
		
	end
	
	if self.extraction_timer then
		
		if self.extraction_timer:GetSeconds() > self.extraction_delay then
		
			self.extraction_timer = nil
			self.drop_timer = Timer()
			
		end
		
	end
	
	if self.drop_timer then
	
		local dt = self.drop_timer:GetMilliseconds()
		local delay = self.drop_delay
	
		self.map:SetAlpha(1 - dt / delay)
		self.marker:SetAlpha(1 - dt / delay)
		self.waypoint:SetAlpha(1 - dt / delay)
	
		if dt > delay then
		
			self.drop_timer = nil
		
		end
		
	end
		
	
	if not self.start_extraction_timer and not self.end_extraction_timer and not self.teleporting and not self.loading and not self.extraction_timer and not self.drop_timer then
	
		self.end_extraction_timer = Timer()
		local ray = Physics:Raycast(Vector3(self.next_position.x, 2100, self.next_position.z), Vector3.Down, 0, 2100)
		Network:Send("CorrectedTeleport", {position = ray.position})	
		
	end
	
	if self.end_extraction_timer then
	
		local dt = self.end_extraction_timer:GetMilliseconds()
		local delay = self.end_extraction_delay
		
		if dt > delay then

			self.end_extraction_timer = nil
			Events:Unsubscribe(self.extraction_sequence)
			Game:FireEvent("ply.makevulnerable")
			self.map:SetAlpha(1)
			self.marker:SetAlpha(1)
			self.waypoint:SetAlpha(1)
			self.render = false
			self.extraction_sequence = nil
			self.extraction_render = nil
			self.previous_position = nil
			self.next_position = nil
			Events:Fire("HideInfo")
			
		end

	end

end

function Map:MapToWorld(position)

	local x = 32768 * (position.x - self.map:GetPosition().x) / self.map:GetSize().x - 16384
	local z = 32768 * (position.y - self.map:GetPosition().y) / self.map:GetSize().y - 16384
	
	local y = Physics:GetTerrainHeight(Vector2(x, z))

	return Vector3(x, y, z)

end

function Map:WorldToMap(position)

	local x = self.map:GetSize().x * (position.x + 16384) / 32768 + self.map:GetPosition().x
	local y = self.map:GetSize().y * (position.z + 16384) / 32768 + self.map:GetPosition().y
	
	return Vector2(x, y)

end

function Map:YawToHeading(yaw)
	if yaw < 0 then
		return -yaw
	else
		return 360 - yaw
	end
end

function Map:OnPostRender()

	if Game:GetState() ~= GUIState.Game then return end
	
	if self.extraction_sequence then
	
		if self.start_extraction_timer then
		
			local dt = self.start_extraction_timer:GetMilliseconds()
			local delay = self.start_extraction_delay
			
			if dt < delay then
				
				Render:FillArea(Vector2.Zero, Render.Size, self:ColorAlpha(Color.Black, 255 * (dt / delay)))
		
			end
			
		end
		
		if self.teleporting or self.loading or self.extraction_timer or self.drop_timer then
		
			Render:FillArea(Vector2.Zero, Render.Size, self:ColorAlpha(Color.Black, 255))
			
		end

		if self.end_extraction_timer then
		
			local dt = self.end_extraction_timer:GetMilliseconds()
			local delay = self.end_extraction_delay
			
			if dt < delay then
		
				Render:FillArea(Vector2.Zero, Render.Size, self:ColorAlpha(Color.Black, 255 * (1 - dt / delay)))
				
			end

		end
	
	end

	if self.render then

		-- Render:FillArea(self.map:GetPosition() - Vector2(3,3), self.map:GetSize() + Vector2(6, 6), self:ColorAlpha(Color.Red, 128))
		
		self.map:Draw()
		
		if not self.extraction_sequence then
		
			if self.network_timer:GetMilliseconds() > self.network_delay then
		
				Network:Send("RequestUpdate")
				self.network_timer:Restart()
			
			end
		
			for _,player in ipairs(self.players) do

				local position = self:WorldToMap(player.position)
				local color = player.color
				
				local str = player.name
			
				Render:FillCircle(position, Render.Height * 0.005, self:ColorAlpha(player.color, 220))
				Render:DrawCircle(position, Render.Height * 0.005, Color.Black)
				
				if self.labels == 2 then
				
					if player.vehicle_name then

						local speed = math.floor(player.velocity:Length() * 3.6)
						local heading = math.floor(self:YawToHeading(math.deg(player.angle.yaw)))
						local altitude = math.floor(player.position.y + 200)
						str = string.format("%s\n%s\n%s km/h : %s m : %s°", player.name, player.vehicle_name, speed, altitude, heading)

					else

						str = nil

					end

				end
				
				if self.labels ~= 0 then

					if str ~= nil then
				
						Render:FillArea(position + Render.Size * 0.001, Vector2(1.05 * Render:GetTextWidth(str, self.text_size), Render:GetTextHeight(str, self.text_size)), self:ColorAlpha(Color.Black, 128))
						Render:DrawText(position + Render.Size * 0.003 + Vector2(2, 2), str, self:ColorAlpha(Color.Black, 64), self.text_size)
						Render:DrawText(position + Render.Size * 0.003 + Vector2(1, 1), str, self:ColorAlpha(Color.Black, 128), self.text_size)
						Render:DrawText(position + Render.Size * 0.003, str, player.color, self.text_size)

					end
					
				end

				if self.labels == 2 then

					if player.angle ~= nil then

						Render:DrawLine(position, position - (Vector2(math.sin(player.angle.yaw), math.cos(player.angle.yaw)) * 120), Color.Lime)

					end

					if LocalPlayer:GetVehicle() ~= nil then

						if self.airv[LocalPlayer:GetVehicle():GetModelId()] and LocalPlayer:GetVehicle():GetDriver() == LocalPlayer then

							local position = self:WorldToMap(LocalPlayer:GetPosition())

							Render:DrawLine(position, position - (Vector2(math.sin(LocalPlayer:GetAngle().yaw), math.cos(LocalPlayer:GetAngle().yaw)) * 120), Color.Pink)	

						end
					
					end

				end
					
			end
			
			local str = "Left-click for extraction.    Middle-click to set waypoint.    Right-click to toggle labels."
			local str_size = Render:GetTextSize(str, self.text_size)
			Render:DrawText(Vector2(0.5 * Render.Width - 0.5 * str_size.x, 0.75 * str_size.y), str, Color.White, self.text_size)

			local number_x = self:MapToWorld(Mouse:GetPosition()).x + 16384
			local number_y = self:MapToWorld(Mouse:GetPosition()).z + 16384
			if number_x > 32768 then
				number_x = 32768
			elseif number_x < 0 then
				number_x = 0
			end
			if number_y > 32768 then
				number_y = 32768
			elseif number_y < 0 then
				number_y = 0
			end
			Render:DrawText(Vector2(0.765 * Render.Width, 0.01 * Render.Height), "X: "..math.ceil(number_x), Color.White, self.text_size)
			Render:DrawText(Vector2(0.765 * Render.Width, 0.025 * Render.Height), "Y: "..math.ceil(number_y), Color.White, self.text_size)
			
		end
		
		if self.extraction_timer then
			local position = math.lerp(self:WorldToMap(self.previous_position), self:WorldToMap(self.next_position), self.extraction_timer:GetSeconds() / self.extraction_delay)
			self.heli:SetPosition(position - 0.5 * self.heli:GetSize())
			self.heli:Draw()
		else
			self.marker:SetPosition(self:WorldToMap(LocalPlayer:GetPosition()) - 0.5 * self.marker:GetSize())
			self.marker:Draw()
			local waypoint, bool = Waypoint:GetPosition()
			if bool then
				self.waypoint:SetPosition(self:WorldToMap(waypoint) - 0.5 * self.waypoint:GetSize())
				self.waypoint:Draw()
			end
		end

	else
		if self.enabled then
			local str = "Press F2 to open a full map."
			local str_size = Render:GetTextSize(str, self.text_size)
			Render:DrawText(Vector2(0.12 * Render.Width, 0.03 * Render.Height), str, Color.White, self.text_size)
		else
			local str = "Type /showonmap to re-enable the map."
			local str_size = Render:GetTextSize(str, self.text_size)
			Render:DrawText(Vector2(0.12 * Render.Width, 0.03 * Render.Height), str, Color.White, self.text_size)
		end	
	end
	
end

function Map:ColorAlpha(color, alpha)

	return Color(color.r, color.g, color.b, alpha)

end

function Map:OnPlayerUpdate(args)

	self.players = args
	
end

function Map:OnResolutionChange(args)

	self.text_size = args.size.y * self.text_scale
	self.waypoint:SetSize(Vector2(1, 1) * args.size.y * self.icon_scale)
	self.marker:SetSize(Vector2(1, 1) * args.size.y * self.icon_scale)
	self.map:SetSize(Vector2(args.size.y, args.size.y) * self.map_scale)
	self.map:SetPosition(Vector2(0.5 * args.size.x - 0.5 * self.map:GetSize().x, 0.5 * args.size.y - 0.5 * self.map:GetSize().y))

end

function Map:InputBlock(args)

	local i = args.input

	if self.extraction_sequence then
		return false
	end
	
	if self.render then
		if self.inputs[i] then
			return false
		end
	end

end

Map = Map()